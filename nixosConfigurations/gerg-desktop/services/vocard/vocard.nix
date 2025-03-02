{
  self',
  lib,
  config,
}:
{
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
      content =
        builtins.replaceStrings
          [
            "@token@"
            "@client_id@"
            "@spotify_client_id@"
            "@spotify_client_secret@"
            "@password@"
          ]
          (builtins.attrValues {
            inherit (config.sops.placeholder)
              "vocard/token"
              "vocard/client_id"
              "vocard/spotify_client_id"
              "vocard/spotify_client_secret"
              "vocard/password"
              ;
          })
          (builtins.readFile ./settings.json);
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

      environment.LAVALINK_PLUGINS_DIR = self'.packages.lavalinkPlugins;

      serviceConfig = {
        ExecStart = "${lib.getExe self'.packages.lavalink} --spring.config.location='file:${./application.yml}'";
        DynamicUser = true;
        EnvironmentFile = config.sops.secrets.lavalink.path;
        Restart = "on-failure";
        RestartSec = "30s";
      };
    };
  };

  services.ferretdb.enable = true;

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
