{ config }:
{
  users = {
    groups.${config.services.forgejo.group} = { };
    users = {
      ${config.services.forgejo.user} = {
        isSystemUser = true;
        inherit (config.services.forgejo) group;
        extraGroups = [ "postgres" ];
        openssh.authorizedKeys.keys = [ config.local.keys.gerg_gerg-desktop ];
      };

      ${config.services.nginx.user}.extraGroups = [ config.services.forgejo.group ];
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
        HTTP_ADDR = "/run/forgejo/forgejo.sock";
        PROTOCOL = "http+unix";
        UNIX_SOCKET_PERMISSION = "660";
      };
      ui.DEFAULT_THEME = "forgejo-dark";
      service.DISABLE_REGISTRATION = true;
    };
    database = {
      type = "postgres";
      createDatabase = true;
    };
  };
}
