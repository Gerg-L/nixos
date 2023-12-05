_:
{config, lib, ...}:
{
  sops.secrets =
    lib.genAttrs
      [
        "nixfu_ssl_cert"
        "nixfu_ssl_key"
        "gerg_ssl_key"
        "gerg_ssl_cert"
      ]
      (
        _: {
          owner = config.services.nginx.user;
          inherit (config.services.nginx) group;
        }
      );

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "_" = {
        default = true;
        forceSSL = true;
        sslCertificate = config.sops.secrets.gerg_ssl_cert.path;
        sslCertificateKey = config.sops.secrets.gerg_ssl_key.path;
        locations."/".return = "404";
      };
      "nix-fu.com" = {
        forceSSL = true;
        sslCertificate = config.sops.secrets.nixfu_ssl_cert.path;
        sslCertificateKey = config.sops.secrets.nixfu_ssl_key.path;
        serverAliases = ["www.nix-fu.com"];
        globalRedirect = "github.com/Gerg-L";
      };
      "search.gerg-l.com" = {
        forceSSL = true;
        sslCertificate = config.sops.secrets.gerg_ssl_cert.path;
        sslCertificateKey = config.sops.secrets.gerg_ssl_key.path;
        locations."/".extraConfig = "uwsgi_pass unix:${config.services.searx.uwsgiConfig.socket};";
        extraConfig = "access_log off;";
      };
      "git.gerg-l.com" = {
        forceSSL = true;
        sslCertificate = config.sops.secrets.gerg_ssl_cert.path;
        sslCertificateKey = config.sops.secrets.gerg_ssl_key.path;
        locations."/".proxyPass = "http://unix:${config.services.gitea.settings.server.HTTP_ADDR}";
      };
      "next.gerg-l.com" = {
        forceSSL = true;
        sslCertificate = config.sops.secrets.gerg_ssl_cert.path;
        sslCertificateKey = config.sops.secrets.gerg_ssl_key.path;
      };
      "flux.gerg-L.com" = {
        forceSSL = true;
        sslCertificate = config.sops.secrets.gerg_ssl_cert.path;
        sslCertificateKey = config.sops.secrets.gerg_ssl_key.path;
        locations."/".proxyPass = "http://unix:${config.systemd.services.miniflux.environment.LISTEN_ADDR}";
      };
    };
  };
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  #_file
}
