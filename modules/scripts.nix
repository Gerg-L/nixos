{ pkgs, config, ... }:

let
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

  apply-user = pkgs.writeShellScriptBin "apply-user" ''
    home-manager switch --flake /etc/nixos/#$(whoami)
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
    apply-user
    sudo -u gerg apply-user
  '';

  polybar-tray = pkgs.writeShellScriptBin "polybar-tray" ''
    u=$(xprop -name "Polybar tray window" _NET_WM_PID | awk '{print $3}')
    if [ $u -Z ]
    then polybar tray &
    else kill $u
    fi
  '';
  pastebin = pkgs.writeShellScriptBin "pastebin" ''
    curl -F 'clbin=<-' https://clbin.com
  '';
in {
  environment.systemPackages = [ update-system clean-store apply-user apply-system polybar-tray full-upgrade pastebin];
}
