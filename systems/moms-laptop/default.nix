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

  system.stateVersion = "23.05";
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
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAuO/3IF+AjH8QjW4DAUV7mjlp2Mryd+1UnpAUofS2yA gerg@gerg-phone"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILpYY2uw0OH1Re+3BkYFlxn0O/D8ryqByJB/ljefooNc gerg@gerg-windows"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJWbwkFJmRBgyWyWU+w3ksZ+KuFw9uXJN3PwqqE7Z/i8 gerg@gerg-desktop"
        ];
        initialHashedPassword = "$6$hgiDFHEMVEA39Snj$Huxf2a/yd/gSO2ZwntxI5Z65c1kCf35lvbkA61knP5i5NLPuIy4cybBBv9lnd24LVR9sfi9Tss96VQdsGCQhq1";
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
