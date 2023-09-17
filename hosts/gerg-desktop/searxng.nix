_: {
  config,
  pkgs,
  ...
}: {
  sops.secrets.searxngenv = {};
  services.searx = {
    enable = true;
    runInUwsgi = false;
    package = pkgs.searxng;
    environmentFile = config.sops.secrets.searxngenv.path;
    settings = {
      server = {
        port = 8765;
        secret_key = "@SEARXNG_SECRET@";
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
}
