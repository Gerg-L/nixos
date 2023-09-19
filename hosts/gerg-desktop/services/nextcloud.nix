_: {
  pkgs,
  config,
  ...
}: {
  sops.secrets = {
    sql_nextcloud = {
      owner = "nextcloud";
      group = "nextcloud";
    };
    nextcloud = {
      owner = "nextcloud";
      group = "nextcloud";
    };
  };
  systemd.tmpfiles.rules = [
    "d /persist/services/nextcloud - nextcloud nextcloud - -"
  ];
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud27;
    datadir = "/persist/services/nextcloud";
    hostName = "next.gerg-l.com";
    autoUpdateApps.enable = false;
    enableBrokenCiphersForSSE = false;
    config = {
      dbtype = "pgsql";
      dbhost = "/run/postgresql";
      dbpassFile = config.sops.secrets.sql_nextcloud.path;
      adminpassFile = config.sops.secrets.sql_nextcloud.path;
      adminuser = "admin-root";
      defaultPhoneRegion = "US";
    };
  };
  systemd.services."nextcloud-setup" = {
    requires = ["postgresql.service"];
    after = ["postgresql.service"];
  };
  _file = ./nextcloud.nix;
}
