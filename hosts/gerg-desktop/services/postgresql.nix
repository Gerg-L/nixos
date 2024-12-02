{ pkgs }:
{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    dataDir = "/persist/services/postgresql";

    ensureDatabases = [ "miniflux" ];
    ensureUsers = [
      {
        name = "miniflux";
        ensureDBOwnership = true;
      }
    ];

    settings.unix_socket_permissions = "0770";
  };
}
