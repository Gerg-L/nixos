{ config }:
let
  link = config.local.links.conduit;
in
{
  networking.firewall.allowedTCPPorts = [ 8448 ];
  local.links.conduit = { };
  services.matrix-conduit = {
    enable = true;
    settings = {
      global = {
        inherit (link) port;
        address = link.ipv4;
        server_name = "gerg-l.com";
        database_backend = "rocksdb";

        max_request_size = 1000 * 1000 * 100 * 20;
        allow_registration = false;
        allow_encryption = true;
        allow_federation = true;
        enable_lightning_bolt = false;
        allow_check_for_updates = false;
        trusted_servers = [
          "matrix.org"
          "nixos.org"
          "libera.chat"
          "conduit.rs"
        ];
      };
    };
  };
  systemd.mounts = [
    {
      what = "/persist/services/conduit";
      where = "/var/lib/private/matrix-conduit";
      type = "none";
      options = "bind";
      wantedBy = [ "conduit.service" ];
      bindsTo = [ "conduit.service" ];
    }
  ];

  local.nginx.defaultVhosts."matrix.gerg-l.com".locations."/" = {
    proxyPass = link.url;
    proxyWebsockets = true;
    extraConfig = ''
      proxy_set_header Host $host;
      proxy_buffering off;
      proxy_read_timeout 5m;
    '';
  };

  services.nginx.virtualHosts."_" = {
    locations."=/.well-known/matrix/server".extraConfig = ''
      add_header Content-Type application/json;
      add_header Access-Control-Allow-Origin *;
      return 200 '{"m.server":"matrix.gerg-l.com:443"}';
    '';
    locations."=/.well-known/matrix/client".extraConfig = ''
      add_header Content-Type application/json;
      add_header Access-Control-Allow-Origin *;
      return 200 '{"m.homeserver": {"base_url": "https://matrix.gerg-l.com:443"}}';
    '';
  };
}
