{
  config,
  lib,
}:
{
  sops.secrets.minifluxenv = { };

  services.miniflux = {
    enable = true;
    config = {
      BASE_URL = "https://flux.gerg-l.com";
      LISTEN_ADDR = "/run/miniflux/miniflux.sock";
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

  systemd.services.miniflux.serviceConfig = {
    RuntimeDirectoryMode = lib.mkForce "0770";
    DynamicUser = lib.mkForce false;
  };

  local.nginx.proxyVhosts."flux.gerg-l.com" =
    "http://unix:${config.services.miniflux.config.LISTEN_ADDR}";
}
