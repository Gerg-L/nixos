{
  config,
  pkgs,
}:
let
  link = config.local.links.nix-serve;
in
{
  local.links.nix-serve = { };

  sops.secrets.store_key = { };

  users = {
    groups.builder = { };
    users.builder = {
      isSystemUser = true;
      openssh.authorizedKeys.keys = [ config.local.keys.root_media-laptop ];
      group = "builder";
      shell = pkgs.bashInteractive;
    };
  };

  services.openssh.extraConfig = ''
    Match User builder
      AllowAgentForwarding no
      AllowTcpForwarding no
      PermitTTY no
      PermitTunnel no
      X11Forwarding no
    Match All
  '';

  nix.settings = {
    trusted-users = [ "builder" ];
    keep-outputs = true;
    keep-derivations = true;
    secret-key-files = config.sops.secrets.store_key.path;
  };

  services.nix-serve = {
    enable = true;
    inherit (link) port;
    package = pkgs.nix-serve-ng;
    bindAddress = link.ipv4;
    secretKeyFile = config.sops.secrets.store_key.path;
  };

  local.nginx.proxyVhosts."cache.gerg-l.com" = link.url;
}
