{
  self',
  lib,
  config,
}:
{
  sops = {
    secrets =
      builtins.mapAttrs
        (
          _: v:
          v
          // {
            sopsFile = ./secrets.yaml;
          }
        )
        {
          "vocard/token" = { };
          "vocard/client_id" = { };
          "vocard/spotify_client_id" = { };
          "vocard/spotify_client_secret" = { };
          "lavalink/refresh_token" = { };
          "lavalink/password" = { };

        };
    templates = {
      vocard = {
        path = "/persist/services/vocard/settings.json";
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
            [
              config.sops.placeholder."vocard/token"
              config.sops.placeholder."vocard/client_id"
              config.sops.placeholder."vocard/spotify_client_id"
              config.sops.placeholder."vocard/spotify_client_secret"
              config.sops.placeholder."lavalink/password"

            ]
            (builtins.readFile ./settings.json);
      };

      lavalink = {
        path = "/persist/services/lavalink/application.yml";
        restartUnits = [
          "vocard.service"
          "lavalink.service"
        ];
        content =
          builtins.replaceStrings
            [
              "@refresh_token@"

              "@password@"
            ]
            [
              config.sops.placeholder."lavalink/refresh_token"

              config.sops.placeholder."lavalink/password"

            ]
            (builtins.readFile ./application.yml);
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /persist/services/vocard - - - - -"
    "d /persist/services/lavalink - - - - -"
  ];

  systemd.services = {
    vocard = {
      wantedBy = [ "multi-user.target" ];
      wants = [
        "network-online.target"
        "lavalink.service"
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
        WorkingDirectory = "/persist/services/vocard";
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
        WorkingDirectory = "/persist/services/lavalink";
        Restart = "on-failure";
        RestartSec = "30s";
      };
    };
  };

  services.ferretdb.enable = true;
}
