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

  config =
    let
      cfg = config.services.nginx;
    in
    {
      local.nginx.defaultVhosts = builtins.mapAttrs (_: v: {
        locations."/".proxyPass = v;
      }) config.local.nginx.proxyVhosts;

      sops.secrets = {
        gerg_ssl_key.owner = cfg.user;
        gerg_ssl_cert.owner = cfg.user;
      };

      security.acme = {
        acceptTerms = true;
        certs."gerg-l.com" = {
          email = "GregLeyda@proton.me";
          inherit (cfg) group;
          webroot = "/var/lib/acme/acme-challenge";
          extraDomainNames = builtins.attrNames config.local.nginx.defaultVhosts;
        };
      };

      systemd.mounts = [
        {
          what = "/persist/services/acme";
          where = "/var/lib/acme";
          type = "none";
          options = "bind";
        }
      ];

      services.nginx = {
        enable = true;
        recommendedZstdSettings = true;
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
