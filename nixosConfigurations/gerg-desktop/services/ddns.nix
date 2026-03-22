{
  config,
}:
{
  sops = {
    secrets.cloudflare = { };
    templates.ddns = {
      restartUnits = [ "ddns-updater.service" ];
      content = builtins.toJSON {
        settings =
          map
            (
              x:
              {
                provider = "cloudflare";
                token = config.sops.placeholder.cloudflare;
                ttl = 1;
                zone_identifier = "8f76f071c5edbc0f947a5c5f9c5df9f8";
                ip_version = "ipv6";
                ipv6_suffix = "0:0:0:0:da5e:d3ff:fee5:4790/64";
              }
              // x
            )
            [
              {
                domain = "*.gerg-l.com";
                proxied = true;
              }
              {
                domain = "gerg-l.com";
                proxied = false;
              }
              {
                domain = "minecraft.gerg-l.com";
                proxied = false;
              }
            ];
      };
    };
  };

  services.ddns-updater = {
    enable = true;
    environment = {
      CONFIG_FILEPATH = "%d/config.json";
      PERIOD = "1h";
      SERVER_ENABLED = "no";
    };
  };
  systemd.services.ddns-updater.serviceConfig.LoadCredential =
    "config.json:${config.sops.templates.ddns.path}";
}
