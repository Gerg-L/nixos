{
  networking.firewall = {
    allowedUDPPorts = [ 24454 ];
    allowedTCPPorts = [
      25565
      25575
    ];
  };
  services.nginx = {
    enable = true;
    config = ''
      events {
        worker_connections 5048;
      }

      stream {
        server {
          listen 25565;
          listen 25575;
          listen 24454;

          resolver 8.8.8.8 ipv4=off;
          resolver_timeout 15s;

          proxy_socket_keepalive on;
          proxy_pass ipv6.gerg-l.com:$server_port;
        }
      }
    '';
  };
}
