{ config }:
let
  cfg = config.services.immich;
  link = config.local.links.immich;
in
{
  sops.secrets.immich.owner = cfg.user;

  local.links.immich = { };
  systemd.tmpfiles.rules = [ "d ${cfg.mediaLocation} - ${cfg.user} ${cfg.group} - -" ];

  services.immich = {
    enable = true;
    openFirewall = true;
    #secretsFile = config.sops.secrets.immich.path;
    database =
      let
        dbLink = config.local.links.postgresql;
      in
      {
        enable = true;
        createDB = true;
        inherit (dbLink) port;
        #host = dbLink.hostname;
      };
    mediaLocation = "/persist/services/immich";
    machine-learning.enable = true;
    settings = null;
    inherit (link) port;
    host = link.hostname;
  };

  local.nginx.proxyVhosts."photos.gerg-l.com" = link.url;
}
