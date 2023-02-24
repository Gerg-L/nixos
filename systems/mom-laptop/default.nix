inputs: {
  pkgs,
  settings,
  ...
}: {
  imports = [
    (import ./printing.nix inputs)
  ];
  localModules = {
    DM = {
      lightdm.enable = true;
      autoLogin = true;
    };
    DE.xfce.enable = true;
    theming = {
      enable = true;
      kmscon.enable = true;
    };
  };

  system.stateVersion = "22.11";
  environment.systemPackages = [
    pkgs.vlc
    pkgs.nomacs
    pkgs.gnome.gnome-calculator
    pkgs.xfce.xfce4-whiskermenu-plugin
    pkgs.rsync
    pkgs.pavucontrol #gui volume control
    pkgs.librewolf #best browser
  ];
  services.xserver.videoDrivers = ["intel"];
  networking = {
    hostName = "mom-laptop";
    networkmanager.enable = true;
  };
  boot.kernelPackages = pkgs.linuxPackages_latest;
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
  boot = {
    initrd.availableKernelModules = ["xhci-pci" "ehci-pci" "ahci" "usbhid" "sd_mod" "sr_mod" "rtsx_usb_sdmmc"];
    kernelModules = ["kvm-intel"];
  };
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/518885c4-2d43-46a5-bf17-c734b7b85c2e";
      fsType = "ext4";
      label = "nixos";
      noCheck = false;
      mountPoint = "/";
      neededForBoot = true;
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/5BCE-813C";
      fsType = "vfat";
      label = "BOOT";
      noCheck = false;
      mountPoint = "/boot";
      neededForBoot = true;
    };
  };
}
