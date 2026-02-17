{ config }:
let
  link = config.local.links.tuwunel;
in
{
  networking.firewall.allowedTCPPorts = [ 8448 ];

  local.links.tuwunel = { };
  services.matrix-tuwunel = {
    enable = true;
    settings = {
      global = {
        port = [ link.port ];
        address = [ link.ipv4 ];
        server_name = "gerg-l.com";
        new_user_displayname_suffix = "";
        max_request_size = 1000 * 1000 * 100 * 20;

        allow_registration = true;
        registration_token_file = config.sops.secrets.tuwunel_reg.path;
        grant_admin_to_first_user = true;

        allow_encryption = true;
        allow_federation = true;

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
      what = "/persist/services/tuwunel";
      where = "/var/lib/private/tuwunel";
      type = "none";
      options = "bind";
      wantedBy = [ "tuwunel.service" ];
      bindsTo = [ "tuwunel.service" ];
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

  sops.secrets.tuwunel_reg.owner = config.services.matrix-tuwunel.user;
}
