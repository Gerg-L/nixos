_:
{ config, pkgs, ... }:
{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_13;
    dataDir = "/persist/services/postgresql";

    ensureDatabases = [
      "miniflux"
      config.services.gitea.database.user
    ];
    ensureUsers = [ {
      name = "miniflux";
      ensurePermissions."DATABASE miniflux" = "ALL PRIVILEGES";
    } ];

    settings.unix_socket_permissions = "0770";
  };
  _file = ./postgresql.nix;
}
