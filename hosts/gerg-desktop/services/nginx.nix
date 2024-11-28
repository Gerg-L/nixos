{ config, lib }:
{
  sops.secrets =
    lib.genAttrs
      [
        "nixfu_ssl_cert"
        "nixfu_ssl_key"
        "gerg_ssl_key"
        "gerg_ssl_cert"
      ]
      (_: {
        owner = config.services.nginx.user;
        inherit (config.services.nginx) group;
      });

  security.acme = {
    acceptTerms = true;
    certs."gerg-l.com" = {
      email = "GregLeyda@proton.me";
      webroot = "/var/lib/acme/acme-challenge";
      extraDomainNames = [
        "search.gerg-l.com"
        "git.gerg-l.com"
        "next.gerg-l.com"
        "flux.gerg-l.com"
        "cache.gerg-l.com"
      ];
    };
  };

  systemd.tmpfiles.rules = [ "L+ /var/lib/acme - - - - /persist/services/acme" ];

  users.users.${config.services.nginx.user}.extraGroups = [ "acme" ];

  services.nginx = {
    enable = true;
    recommendedZstdSettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "_" = {
        default = true;
        forceSSL = true;
        useACMEHost = "gerg-l.com";

        locations."/".return = "404";
      };
      "search.gerg-l.com" = {
        forceSSL = true;
        useACMEHost = "gerg-l.com";

        locations."/".extraConfig = "uwsgi_pass unix:${config.services.searx.uwsgiConfig.socket};";
        extraConfig = "access_log off;";
      };
      "git.gerg-l.com" = {
        forceSSL = true;
        useACMEHost = "gerg-l.com";

        locations."/".proxyPass = "http://unix:${config.services.forgejo.settings.server.HTTP_ADDR}";
      };
      "flux.gerg-L.com" = {
        forceSSL = true;
        useACMEHost = "gerg-l.com";

        locations."/".proxyPass = "http://unix:${config.systemd.services.miniflux.environment.LISTEN_ADDR}";
      };
      "next.gerg-l.com" = {
        forceSSL = true;
        useACMEHost = "gerg-l.com";
        extraConfig = ''
          zstd on;
          zstd_types "*";
        '';
      };
      "cache.gerg-L.com" = {
        forceSSL = true;
        useACMEHost = "gerg-l.com";

        locations."/" = {
          proxyPass = "http://unix:/run/nix-serve/nix-serve.sock";
          extraConfig = ''
            zstd on;
            zstd_types "*";
          '';
        };
      };
    };
  };
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
