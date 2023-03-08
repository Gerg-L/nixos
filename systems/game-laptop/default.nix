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
    pkgs.pavucontrol #gui volume control
    pkgs.pcmanfm #file manager
    pkgs.librewolf #best browser
    pkgs.webcord
    #   inputs.suckless.packages.${pkgs.system}.st
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
        extraGroups = ["networkmanager" "audio"];
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
    kernelPackages = pkgs.linuxPackages_zen;
  };
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/0822f37a-e55b-4b56-aeae-b6f4a11306c3";
      fsType = "ext4";
      label = "nixos";
      noCheck = false;
      mountPoint = "/";
      neededForBoot = true;
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/EA2C-E488";
      fsType = "vfat";
      label = "BOOT";
      noCheck = false;
      mountPoint = "/boot";
      neededForBoot = true;
    };
  };
}
