{ config, pkgs }:
{
  sops.secrets.searxngenv = { };
  users.users.${config.services.nginx.user}.extraGroups = [ "searx" ];
  services.searx = {
    enable = true;
    package = pkgs.searxng;
    runInUwsgi = true;
    uwsgiConfig = {
      socket = "/run/searx/searx.sock";
      chmod-socket = "660";
      disable-logging = true;
    };
    environmentFile = config.sops.secrets.searxngenv.path;
    settings = {
      general.instance_name = "Gerg search";
      server = {
        secret_key = "@SEARXNG_SECRET@";
        base_url = "https://search.gerg-l.com";
      };
      search.formats = [
        "html"
        "json"
      ];
      engines = [
        {
          name = "bing";
          disabled = true;
        }
        {
          name = "brave";
          disabled = true;
        }
      ];
      ui.theme_args.simple_style = "dark";
    };
  };

  local.nginx.defaultVhosts."search.gerg-l.com" = {
    locations."/".extraConfig = "uwsgi_pass unix:${config.services.searx.uwsgiConfig.socket};";
    extraConfig = "access_log off;";
  };
}
