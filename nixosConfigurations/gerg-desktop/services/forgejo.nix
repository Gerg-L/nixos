{ config }:
let
  link = config.local.links.forgejo;
in
{
  local.links.forgejo = { };
  users = {
    groups.${config.services.forgejo.group} = { };
    users = {
      ${config.services.forgejo.user} = {
        isSystemUser = true;
        inherit (config.services.forgejo) group;
        extraGroups = [ "postgres" ];
        openssh.authorizedKeys.keys = [ config.local.keys.gerg_gerg-desktop ];
      };

    };
  };
  services.forgejo = {
    enable = true;
    stateDir = "/persist/services/forgejo";
    settings = {
      DEFAULT.APP_NAME = "Powered by NixOS";
      server = {
        DOMAIN = "git.gerg-l.com";
        ROOT_URL = "https://git.gerg-l.com/";
        LANDING_PAGE = "/explore/repos";
        HTTP_ADDR = link.ipv4;
        HTTP_PORT = link.port;
      };
      ui.DEFAULT_THEME = "forgejo-dark";
      service.DISABLE_REGISTRATION = true;
    };
    database = {
      type = "postgres";
      createDatabase = true;
    };
  };

  local.nginx.proxyVhosts."git.gerg-l.com" = link.url;
}
