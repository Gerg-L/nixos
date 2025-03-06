{
  lib,
  config,
}:
let
  link = config.local.links.miniflux;
in
{
  local.links.miniflux = { };

  sops.secrets.minifluxenv = { };

  services.miniflux = {
    enable = true;
    config = {
      BASE_URL = "https://flux.gerg-l.com";
      LISTEN_ADDR = link.tuple;
      DATABASE_URL =
        let
          dbLink = config.local.links.postgresql;
        in
        lib.mkForce "user=miniflux host=${dbLink.hostname} port=${dbLink.portStr} dbname=miniflux sslmode=disable";
    };
    adminCredentialsFile = config.sops.secrets.minifluxenv.path;
    createDatabaseLocally = true;
  };

  local.nginx.proxyVhosts."flux.gerg-l.com" = link.url;
}
