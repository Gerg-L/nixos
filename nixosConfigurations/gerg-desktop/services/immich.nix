{ config, ... }:
let
  cfg = config.services.immich;
  link = config.local.links.immich;
in
{
  local.links.immich = { };
  systemd.tmpfiles.rules = [ "d ${cfg.mediaLocation} - ${cfg.user} ${cfg.group} - -" ];

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
    inherit (link) port;
    host = link.ipv4;
  };

  local.nginx.proxyVhosts."photos.gerg-l.com" = link.url;
}
