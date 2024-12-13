{ config, ... }:
{
  users.users.${config.services.immich.user}.extraGroups = [ "postgres" ];
  services.immich = {
    enable = true;
    openFirewall = true;
    database = {
      enable = true;
      createDB = true;
    };
    mediaLocation = "/persist/services/immich";
    machine-learning.enable = false;
    settings = null;
    port = 2283;
    host = "0.0.0.0";
  };

  local.nginx.proxyVhosts."photos.gerg-l.com" =
    "http://localhost:${toString config.services.immich.port}";
}
