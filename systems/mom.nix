inputs:{
  pkgs,
  settings,
  lib,
  ...
}: {
  imports = [
      (import ../imports/boot.nix inputs)
      (import ../imports/fonts.nix inputs)
      (import ../imports/git.nix inputs)
      (import ../imports/packages.nix inputs)
      (import ../imports/xfce.nix inputs)
      (import ../imports/shells.nix inputs)
      (import ../imports/theme.nix inputs)
    ];
  nixpkgs.allowedUnfree = ["hplip"];
  system.stateVersion = "22.11";
  environment.systemPackages = [
    pkgs.gimp
    (pkgs.xsane.override {gimpSupport = true;})
    pkgs.vlc
    pkgs.libreoffice
    pkgs.nomacs
    pkgs.gnome.gnome-calculator
    pkgs.xfce.xfce4-whiskermenu-plugin
    pkgs.rsync
  ];
  services.xserver.videoDrivers = ["intel"];
  networking.hostName = settings.hostname;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.cpu.intel.updateMicrocode = true;
  #printing stuff
  hardware.sane = {
    enable = true;
    extraBackends = [pkgs.hplipWithPlugin];
    #run this to setup gimp plugin
    #ln -s /run/current-system/sw/bin/xsane ~/.config/GIMP/2.10/plug-ins/xsane
  };
  services = {
    printing = {
      enable = true;
      drivers = [pkgs.hplipWithPlugin];
    };
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users."${settings.username}" = {
      uid = 1000;
      isNormalUser = true;
      extraGroups = ["audio" "networkmanager" "scanner" "lp" "cups"];
    };
  };
  services.xserver.displayManager.autoLogin = {
    enable = true;
    user = settings.username;
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
