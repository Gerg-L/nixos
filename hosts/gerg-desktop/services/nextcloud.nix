_:
{ pkgs, config, ... }:
{
  #sops.secrets.nextcloud.owner = "nextcloud";

  #users.users.nextcloud.extraGroups = [ "postgres" ];

  services.nextcloud = {
    enable = false;
    package = pkgs.nextcloud28;
    datadir = "/persist/services/nextcloud";
    hostName = "next.gerg-l.com";
    autoUpdateApps.enable = false;
    database.createLocally = true;
    config = {
      dbtype = "pgsql";
      adminpassFile = config.sops.secrets.nextcloud.path;
      adminuser = "admin-root";
    };
    settings = {
      overwriteprotocol = "https";
      default_phone_region = "US";
    };
  };
  #_file
}
