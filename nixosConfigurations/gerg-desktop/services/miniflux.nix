{
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
    };
    adminCredentialsFile = config.sops.secrets.minifluxenv.path;
    createDatabaseLocally = true;
  };

  users = {
    groups.miniflux.gid = 377;
    users = {
      miniflux = {
        group = "miniflux";
        extraGroups = [ "postgres" ];
        isSystemUser = true;
        uid = 377;
      };
      ${config.services.nginx.user}.extraGroups = [ "miniflux" ];
    };
  };

  local.nginx.proxyVhosts."flux.gerg-l.com" = link.url;
}
