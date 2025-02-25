{ config, ... }:
let
  cfg = config.services.immich;
in
{
  systemd.tmpfiles.rules =

    [ "d ${cfg.mediaLocation} - ${cfg.user} ${cfg.group} - -" ];

  users.users.${cfg.user}.extraGroups = [ "postgres" ];
  services.immich = {
    enable = true;
    openFirewall = true;
    database = {
      enable = true;
      createDB = true;
    };
    mediaLocation = "/persist/services/immich";
    machine-learning.enable = true;
    settings = null;
    port = 2283;
    host = "0.0.0.0";
  };

  local.nginx.proxyVhosts."photos.gerg-l.com" = "http://localhost:${toString cfg.port}";
}
