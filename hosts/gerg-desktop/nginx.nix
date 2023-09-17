_: {
  config,
  lib,
  ...
}: {
  sops.secrets = lib.mapAttrs (_: v:
    {
      owner = "nginx";
      group = "nginx";
    }
    // v) {
    nixfu_ssl_cert = {};
    nixfu_ssl_key = {};
    gerg_ssl_key = {};
    gerg_ssl_cert = {};
  };
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "nix-fu.com" = {
        forceSSL = true;
        sslCertificate = config.sops.secrets.nixfu_ssl_cert.path;
        sslCertificateKey = config.sops.secrets.nixfu_ssl_key.path;
        serverAliases = ["www.nix-fu.com" "nix-fu.com"];
        locations."/".return = "301 $scheme://www.github.com/Gerg-L$request_uri";
      };
      "search.Gerg-L.com" = {
        forceSSL = true;
        sslCertificate = config.sops.secrets.gerg_ssl_cert.path;
        sslCertificateKey = config.sops.secrets.gerg_ssl_key.path;
        locations."/".proxyPass = "http://localhost:${toString config.services.searx.settings.server.port}";
      };
      "git.Gerg-L.com" = {
        forceSSL = true;
        sslCertificate = config.sops.secrets.gerg_ssl_cert.path;
        sslCertificateKey = config.sops.secrets.gerg_ssl_key.path;
        locations."/".proxyPass = "http://192.168.1.11:3000";
      };
      "next.Gerg-L.com" = {
        forceSSL = true;
        sslCertificate = config.sops.secrets.gerg_ssl_cert.path;
        sslCertificateKey = config.sops.secrets.gerg_ssl_key.path;
        locations."/".proxyPass = "http://192.168.1.11:80";
      };
    };
  };
  networking.firewall = {
    allowedTCPPorts = [80 443];
  };
}
