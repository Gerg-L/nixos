_: {config, ...}: {
  sops.secrets = {
    ssl_cert = {
      owner = "nginx";
      group = "nginx";
    };
    ssl_key = {
      owner = "nginx";
      group = "nginx";
    };
  };
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."nix-fu.com" = {
      forceSSL = true;
      sslCertificate = config.sops.secrets.ssl_cert.path;
      sslCertificateKey = config.sops.secrets.ssl_key.path;
      serverAliases = ["www.nix-fu.com" "nix-fu.com"];
      locations."/".return = "301 $scheme://www.github.com/Gerg-L$request_uri";
    };
  };
  networking.firewall = {
    allowedTCPPorts = [80 443];
  };
}
