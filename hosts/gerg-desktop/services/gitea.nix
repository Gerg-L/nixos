_:
{ config, ... }:
{
  users.users = {
    ${config.services.gitea.user} = {
      openssh.authorizedKeys.keys = [ config.local.keys.gerg_gerg-desktop ];
      extraGroups = [ "postgres" ];
    };
    ${config.services.nginx.user}.extraGroups = [ config.services.gitea.group ];
  };
  services.gitea = {
    enable = true;
    stateDir = "/persist/services/gitea";
    appName = "Powered by NixOS";
    settings = {
      server = {
        DOMAIN = "git.gerg-l.com";
        ROOT_URL = "https://git.gerg-l.com/";
        LANDING_PAGE = "/explore/repos";
        HTTP_ADDR = "/run/gitea/gitea.sock";
        PROTOCOL = "http+unix";
        UNIX_SOCKET_PERMISSION = "660";
      };
      ui.DEFAULT_THEME = "arc-green";
      service.DISABLE_REGISTRATION = true;
    };
    database = {
      type = "postgres";
      socket = "/run/postgresql";
      createDatabase = true;
    };
  };
  #_file
}
