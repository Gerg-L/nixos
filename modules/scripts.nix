{
  pkgs,
  config,
  ...
}: let
  update-system = pkgs.writeShellScriptBin "update-system" ''
    if ! [ $(id -u) = 0 ]; then
      echo "RUN AS ROOT"
      exit 1
    fi
     nix flake update /etc/nixos/#
  '';

  clean-store = pkgs.writeShellScriptBin "clean-store" ''
    if ! [ $(id -u) = 0 ]; then
      echo "RUN AS ROOT"
      exit 1
    fi
    rm /nix/var/nix/gcroots/auto/*
    nix-collect-garbage -d
  '';

  apply-system = pkgs.writeShellScriptBin "apply-system" ''
    if ! [ $(id -u) = 0 ]; then
      echo "RUN AS ROOT"
      exit 1
    fi
    nixos-rebuild switch --flake /etc/nixos/#
  '';

  full-upgrade = pkgs.writeShellScriptBin "full-upgrade" ''
    if ! [ $(id -u) = 0 ]; then
      echo "RUN AS ROOT"
      exit 1
    fi
    update-system
    apply-system
  '';

  pastebin = pkgs.writeShellScriptBin "pastebin" ''
    curl -F 'clbin=<-' https://clbin.com
  '';
in {
  environment.systemPackages = [update-system apply-system full-upgrade clean-store pastebin];
}
