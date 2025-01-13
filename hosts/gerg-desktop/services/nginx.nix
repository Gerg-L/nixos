{ config, lib }:
{
  options.local.nginx = {
    proxyVhosts = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
    };
    defaultVhosts = lib.mkOption {
      type = lib.types.attrs;
    };
  };

  config = {
    local.nginx.defaultVhosts = builtins.mapAttrs (_: v: {
      locations."/".proxyPass = v;
    }) config.local.nginx.proxyVhosts;

    sops.secrets = {
      gerg_ssl_key.owner = config.services.nginx.user;
      gerg_ssl_cert.owner = config.services.nginx.user;
    };

    security.acme = {
      acceptTerms = true;
      certs."gerg-l.com" = {
        email = "GregLeyda@proton.me";
        webroot = "/var/lib/acme/acme-challenge";
        extraDomainNames = builtins.attrNames config.local.nginx.defaultVhosts;
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
      # For immich
      clientMaxBodySize = "50000M";
      proxyTimeout = "600s";
      virtualHosts =
        builtins.mapAttrs
          (
            _: v:
            {
              forceSSL = true;
              useACMEHost = "gerg-l.com";
            }
            // v
          )
          (
            config.local.nginx.defaultVhosts
            // {
              "_" = {
                default = true;
                locations."/".return = "404";
              };
            }
          );
    };
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
