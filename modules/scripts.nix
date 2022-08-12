{ pkgs, config, ... }:

let
  update-system = pkgs.writeScriptBin "update-system" ''
     #!/bin/sh
    if ! [ $(id -u) = 0 ]; then
      echo "RUN AS ROOT"
      exit 1
    fi
     nix flake update /etc/nixos/#
  ''; 

  clean-store = pkgs.writeScriptBin "clean-store" ''
    #!/bin/sh
    if ! [ $(id -u) = 0 ]; then
      echo "RUN AS ROOT"
      exit 1
    fi
    rm /nix/var/nix/gcroots/auto/*
    nix-collect-garbage -d
    sudo -u gerg nix-collect-garbage -d
  ''; 

  apply-users = pkgs.writeScriptBin "apply-users" ''
    #!/bin/sh
    home-manager switch --flake /etc/nixos/#$(whoami)
  ''; 

  apply-system = pkgs.writeScriptBin "apply-system" ''
    #!/bin/sh
    if ! [ $(id -u) = 0 ]; then
      echo "RUN AS ROOT"
      exit 1
    fi
    nixos-rebuild switch --flake /etc/nixos/#${config.networking.hostName}
  ''; 

  polybar-tray = pkgs.writeScriptBin "polybar-tray" ''
    #!/bin/sh
    u=$(xprop -name "Polybar tray window" _NET_WM_PID | awk '{print $3}')
    if [ $u -Z ]
    then polybar tray &
    else kill $u
    fi
  '';
  full-upgrade = pkgs.writeScriptBin "full-upgrade" ''
    #!/bin/sh
    if ! [ $(id -u) = 0 ]; then
      echo "RUN AS ROOT"
      exit 1
    fi
    update-system
    apply-system
    apply-users
    sudo -u gerg apply-users
    clean-store
  '';
in {
  environment.systemPackages = [ update-system clean-store apply-users apply-system polybar-tray full-upgrade];
}
