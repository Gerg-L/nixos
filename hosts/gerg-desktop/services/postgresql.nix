_: {
  config,
  pkgs,
  ...
}: {
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_13;
    dataDir = "/persist/services/postgresql";
    ensureDatabases = [
      config.services.nextcloud.config.dbname
      config.services.gitea.database.user
    ];
    ensureUsers = [
      {
        name = config.services.nextcloud.config.dbuser;
        ensurePermissions."DATABASE ${config.services.nextcloud.config.dbname}" = "ALL PRIVILEGES";
      }
      {
        name = config.services.gitea.database.user;

        ensurePermissions."DATABASE ${config.services.gitea.database.name}" = "ALL PRIVILEGES";
      }
    ];
  };
  _file = ./postgresql.nix;
}
