{
  lib,
  pkgs,
  config,
}:
let
  link = config.local.links.postgresql;
in
{
  local.links.postgresql.port = 5432;

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    dataDir = "/persist/services/postgresql";
    settings = {
      inherit (link) port;
      listen_addresses = lib.mkForce link.ipv4;
      #unix_socket_directories = "";
    };
  };
}
