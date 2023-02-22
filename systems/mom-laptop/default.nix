inputs: {
  pkgs,
  settings,
  ...
}: {
  imports = [
    (import ./printing.nix inputs)
    (import ../imports/fonts.nix inputs)
    (import ../imports/git.nix inputs)
    (import ../imports/shells.nix inputs)
    (import ../imports/theme.nix inputs)
  ];
  localModules = {
    DM = {
      lightdm.enable = true;
      autoLogin = true;
    };
    DE.xfce.enable = true;
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
    hostName = settings.hostname;
    networkmanager.enable = true;
  };
  boot.kernelPackages = pkgs.linuxPackages_latest;
  users.users."${settings.username}" = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = ["audio" "networkmanager"];
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
