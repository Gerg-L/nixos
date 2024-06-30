{ config, pkgs }:
{
  sops.secrets.store_key.owner = "nix-serve";

  users = {
    groups = {
      builder = { };
      nix-serve = { };
    };
    users = {
      ${config.services.nginx.user}.extraGroups = [ "nix-serve" ];
      builder = {
        isSystemUser = true;
        openssh.authorizedKeys.keys = [ config.local.keys.root_media-laptop ];
        group = "builder";
        shell = pkgs.bashInteractive;
      };
      nix-serve = {
        isSystemUser = true;
        group = "nix-serve";
      };
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
    allowed-users = [ "nix-serve" ];
    keep-outputs = true;
    keep-derivations = true;
    secret-key-files = config.sops.secrets.store_key.path;
  };

  systemd.services.nix-serve = {
    description = "nix-serve binary cache server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    path = [
      config.nix.package
      pkgs.bzip2
      pkgs.nix-serve-ng
    ];

    environment = {
      NIX_REMOTE = "daemon";
      NIX_SECRET_KEY_FILE = config.sops.secrets.store_key.path;
    };

    script = ''
      nix-serve --socket /run/nix-serve/nix-serve.sock &
      PID=$!
      sleep 1
      chmod 660 /run/nix-serve/nix-serve.sock
      wait "$PID"
    '';

    serviceConfig = {
      Restart = "always";
      RestartSec = "5s";
      User = "nix-serve";
      Group = "nix-serve";
    };
  };
  systemd.tmpfiles.rules = [ "d /run/nix-serve - nix-serve nix-serve - -" ];
}
