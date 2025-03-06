{ config }:
let
  link = config.local.links.forgejo;
in
{
  sops.secrets.forgejo.owner = config.services.forgejo.user;
  local.links.forgejo = { };

  users.users.${config.services.forgejo.user}.openssh.authorizedKeys.keys = [
    config.local.keys.gerg_gerg-desktop
  ];

  services.forgejo = {
    enable = true;
    stateDir = "/persist/services/forgejo";
    settings = {
      DEFAULT.APP_NAME = "Powered by NixOS";
      server = {
        DOMAIN = "git.gerg-l.com";
        ROOT_URL = "https://git.gerg-l.com/";
        LANDING_PAGE = "/explore/repos";
        PROTOCOL = link.protocol;
        HTTP_ADDR = link.ipv4;
        HTTP_PORT = link.port;
      };
      ui.DEFAULT_THEME = "forgejo-dark";
      service.DISABLE_REGISTRATION = true;
      database.LOG_SQL = false;
    };
    database =
      let
        dbLink = config.local.links.postgresql;
      in
      {
        type = "postgres";
        createDatabase = true;
        inherit (dbLink) port;
        host = dbLink.hostname;
        passwordFile = config.sops.secrets.forgejo.path;
      };
  };

  local.nginx.proxyVhosts."git.gerg-l.com" = link.url;
}
