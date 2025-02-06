{
  self',
  lib,
}:
{
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
