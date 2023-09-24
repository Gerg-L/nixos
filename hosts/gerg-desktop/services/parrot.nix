_:
{
  pkgs,
  config,
  lib,
  ...
}:
{
  sops.secrets.discordenv = { };
  systemd.services.parrot = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    script = lib.getExe pkgs.parrot;
    serviceConfig = {
      EnvironmentFile = config.sops.secrets.discordenv.path;
      Restart = "on-failure";
      RestartSec = "30s";
    };
  };
  _file = ./parrot.nix;
}
