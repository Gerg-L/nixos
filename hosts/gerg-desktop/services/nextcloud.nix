_:
{ pkgs, config, ... }:
{
  sops.secrets.nextcloud.owner = "nextcloud";

  users.users.nextcloud.extraGroups = [ "postgres" ];

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud27;
    datadir = "/persist/services/nextcloud";
    hostName = "next.gerg-l.com";
    autoUpdateApps.enable = false;
    enableBrokenCiphersForSSE = false;
    database.createLocally = true;
    config = {
      overwriteProtocol = "https";
      dbtype = "pgsql";
      adminpassFile = config.sops.secrets.nextcloud.path;
      adminuser = "admin-root";
      defaultPhoneRegion = "US";
    };
  };
  _file = ./nextcloud.nix;
}
