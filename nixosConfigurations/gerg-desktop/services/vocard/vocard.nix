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
    secrets =
      {
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
        ExecStart =
          let
            configFile = pkgs.writeText "application.yml" (
              builtins.toJSON (
                import ./_application.nix {
                  inherit link;
                  inherit (self'.packages) lavalinkPlugins;
                }
              )
            );
          in

          "${lib.getExe self'.packages.lavalink} --spring.config.location='file:${configFile}'";
        DynamicUser = true;
        EnvironmentFile = config.sops.secrets.lavalink.path;
        Restart = "on-failure";
        RestartSec = "30s";
      };
    };
  };

  services.ferretdb = {
    enable = true;
    settings.FERRETDB_LISTEN_ADDR = ferretLink.tuple;
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
