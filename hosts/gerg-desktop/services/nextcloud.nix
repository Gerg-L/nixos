{ pkgs, config }:
{
  sops.secrets.nextcloud.owner = "nextcloud";

  users.users.nextcloud.extraGroups = [ "postgres" ];

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud29;
    home = "/persist/services/nextcloud";
    datadir = "/persist/services/nextcloud";
    extraAppsEnable = false;
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
}
