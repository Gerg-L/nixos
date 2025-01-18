{ pkgs }:
{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    dataDir = "/persist/services/postgresql";
    settings.unix_socket_permissions = "0770";
  };
}
