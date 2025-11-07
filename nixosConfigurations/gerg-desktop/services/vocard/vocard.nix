{
  self',
  lib,
  config,
  pkgs,
}:
let
  link = config.local.links.lavalink;
  ferretLink = config.local.links.ferretdb;
in
{
  local.links = {
    lavalink = { };
    ferretdb.protocol = "mongodb";
  };

  sops = {
    secrets = {
      ferretdb = { };
      lavalink = {
        sopsFile = ./secrets.yaml;
        restartUnits = [
          "vocard.service"
          "lavalink.service"
        ];
      };

    }
    // builtins.listToAttrs (
      map
        (x: {
          name = "vocard/${x}";
          value.sopsFile = ./secrets.yaml;
        })
        [
          "token"
          "client_id"
          "spotify_client_id"
          "spotify_client_secret"
          "password"
        ]
    );

    templates.vocard = {
      restartUnits = [
        "vocard.service"
        "lavalink.service"
      ];
      content = builtins.toJSON (
        import ./_settings.nix {
          inherit link ferretLink;
          p = config.sops.placeholder;
        }
      );
    };
  };

  systemd.services = {
    vocard = {
      wantedBy = [ "multi-user.target" ];

      bindsTo = [ "lavalink.service" ];

      requires = [
        "network-online.target"
        "ferretdb.service"
      ];
      after = [
        "syslog.target"
        "network-online.target"
        "lavalink.service"
        "ferretdb.service"
      ];
      serviceConfig = {
        ExecStart = lib.getExe self'.packages.vocard;
        DynamicUser = true;
        LoadCredential = "settings.json:${config.sops.templates.vocard.path}";
        Restart = "on-failure";
        RestartSec = "30s";
      };
    };

    lavalink = {
      wants = [ "network-online.target" ];
      after = [
        "syslog.target"
        "network-online.target"
      ];

      serviceConfig = {
        ExecStart = lib.getExe self'.packages.lavalink;
        WorkingDirectory = lib.pipe ./_application.nix [
          (lib.flip import {
            inherit link;
            inherit (self'.packages) lavalinkPlugins;
          })
          builtins.toJSON
          (pkgs.writeTextDir "application.yml")
        ];
        DynamicUser = true;
        EnvironmentFile = config.sops.secrets.lavalink.path;
        Restart = "on-failure";
        RestartSec = "30s";
      };
    };
  };

  services.postgresql = {
    ensureDatabases = [ "ferretdb" ];
    ensureUsers = [
      {
        name = "ferretdb";
        ensureDBOwnership = true;
      }
    ];
  };

  systemd.services.ferretdb = {
    description = "FerretDB";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    environment = {
      FERRETDB_HANDLER = "pg";
      FERRETDB_LISTEN_ADDR = ferretLink.tuple;
    };

    serviceConfig = {
      ExecStart =
        let
          dbLink = config.local.links.postgresql;
        in
        "${lib.getExe pkgs.ferretdb} --debug-addr='-' --telemetry='disable' --postgresql-url=\"postgres:///ferretdb?user=ferretdb&host=${dbLink.hostname}&port=${dbLink.portStr}&passfile=\${CREDENTIALS_DIRECTORY}/password\"";
      Type = "simple";
      StateDirectory = "ferretdb";
      WorkingDirectory = "%S/ferretdb";
      LoadCredential = "password:${config.sops.secrets.ferretdb.path}";
      Restart = "on-failure";
      ProtectHome = true;
      ProtectSystem = "strict";
      PrivateTmp = true;
      PrivateDevices = true;
      ProtectHostname = true;
      ProtectClock = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectControlGroups = true;
      NoNewPrivileges = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      RemoveIPC = true;
      PrivateMounts = true;
      DynamicUser = true;
    };
  };

  systemd.mounts = [
    {
      what = "/persist/services/ferretdb";
      where = "/var/lib/private/ferretdb";
      wantedBy = [ "ferretdb.service" ];
      bindsTo = [ "ferretdb.service" ];
      type = "none";
      options = "bind";
    }
  ];
}
