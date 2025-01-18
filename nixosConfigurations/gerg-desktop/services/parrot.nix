{
  pkgs,
  config,
  lib,
}:
{
  sops.secrets.discordenv = { };

  systemd.services.parrot = {
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];

    environment.SETTINGS_PATH = "/persist/services/parrot";

    serviceConfig = {
      ExecStart = lib.getExe pkgs.parrot;
      EnvironmentFile = config.sops.secrets.discordenv.path;
      Restart = "on-failure";
      RestartSec = "30s";
    };
  };
}
