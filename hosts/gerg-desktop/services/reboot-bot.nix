{
  config,
  lib,
  reboot-bot,
}:
{
  sops.secrets.reboot_token = { };

  systemd.services.reboot_bot = {
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];

    serviceConfig = {
      ExecStart = lib.getExe reboot-bot.packages.default;
      EnvironmentFile = config.sops.secrets.reboot_token.path;
      Restart = "on-failure";
      RestartSec = "30s";
    };
  };
}
