inputs: {
  pkgs,
  lib,
  settings,
  config,
  ...
}: {
  imports = [
    (import ./prime.nix inputs)
    (import ./gaming.nix inputs)
  ];

  disko.devices = import ./disko.nix;

  localModules = {
    DE.gnome.enable = true;
    DM = {
      lightdm.enable = true;
      autoLogin = true;
    };
    theming = {
      enable = true;
      kmscon.enable = true;
    };
  };
  nixpkgs.allowedUnfree = [
    "nvidia-x11"
    "nvidia-persistenced"
    "steam"
    "steam-original"
    "steam-run"
  ];
  system.stateVersion = "unstable";
  environment.systemPackages = [
    pkgs.pcmanfm #file manager
    pkgs.librewolf #best browser
    pkgs.webcord
    (pkgs.obs-studio.overrideAttrs (old: rec {
      preFixup =
        old.preFixup
        + ''
          qtWrapperArgs+=(
            --prefix LD_LIBRARY_PATH : "/run/opengl-driver/lib"
          )
        '';
    }))
    pkgs.vlc
  ];
  networking = {
    hostName = "game-laptop";
    networkmanager.enable = true;
  };
  #user managment
  sops.secrets.root.neededForUsers = true;
  users = {
    mutableUsers = false;
    users = {
      "${settings.username}" = {
        useDefaultShell = true;
        uid = 1000;
        isNormalUser = true;
        extraGroups = ["audio"];
        initialHashedPassword = "";
      };
      "root" = {
        uid = 0;
        home = "/root";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAuO/3IF+AjH8QjW4DAUV7mjlp2Mryd+1UnpAUofS2yA gerg@gerg-phone"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILpYY2uw0OH1Re+3BkYFlxn0O/D8ryqByJB/ljefooNc gerg@gerg-windows"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJWbwkFJmRBgyWyWU+w3ksZ+KuFw9uXJN3PwqqE7Z/i8 gerg@gerg-desktop"
        ];
        passwordFile = config.sops.secrets.root.path;
      };
    };
  };
  environment.interactiveShellInit = lib.mkForce ''
    export TERMINAL=gnome-terminal
    fetch-rs
  '';
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  boot = {
    initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci"];
    kernelModules = ["kvm-amd"];
    kernelPackages = pkgs.linuxPackages_latest;
  };
  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024;
    }
  ];
}
