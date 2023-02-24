inputs: {
  pkgs,
  settings,
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
  system.stateVersion = "23.05";
  environment.systemPackages = [
    pkgs.pavucontrol #gui volume control
    pkgs.pcmanfm #file manager
    pkgs.librewolf #best browser
    pkgs.webcord
    inputs.suckless.packages.${pkgs.system}.st
  ];
  networking = {
    hostName = settings.hostname;
    networkmanager.enable = true;
  };
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
        initialHashedPassword = "$6$KV00qSRKyx1hpZjX$kwzWN4UuQxHSFwA4vYtRTcYecQyR.Qelvvcr90ZfZ4y.LISUcx2PDHH9/7REwsoAHD./KlAnwlsm1hxeLoGpl/";
      };
    };
  };
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
