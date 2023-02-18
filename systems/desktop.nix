inputs: {
  pkgs,
  settings,
  ...
}: {
  imports = [
    (import ../imports/boot.nix inputs)
    (import ../imports/dwm.nix inputs)
    (import ../imports/fonts.nix inputs)
    (import ../imports/git.nix inputs)
    (import ../imports/packages.nix inputs)
    (import ../imports/parrot.nix inputs)
    (import ../imports/picom.nix inputs)
    (import ../imports/refreshrate.nix inputs)
    (import ../imports/shells.nix inputs)
    (import ../imports/sxhkd.nix inputs)
    (import ../imports/theme.nix inputs)
    (import ../imports/vfio.nix inputs)
    #   (import ../imports/mining.nix inputs)
    (import ../imports/spicetify.nix inputs)
  ];
  system.stateVersion = "23.05";
  environment.systemPackages = with pkgs; [
    webcord # talk to people (gross)
    bitwarden #store stuff
    qbittorrent #steal stuff
    networkmanagerapplet #gui connection control
    vlc #play stuff
  ];
  networking.hostName = settings.hostname;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.cpu.amd.updateMicrocode = true;
  #user managment
  users = {
    users."${settings.username}" = {
      uid = 1000;
      isNormalUser = true;
      extraGroups = ["wheel" "audio" "networkmanager"];
    };
  };
  boot = {
    initrd = {
      kernelModules = ["amdgpu"];
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "sd_mod"];
      supportedFilesystems = ["ext4" "vfat"];
      includeDefaultModules = false;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/9e5c0a74-753a-4ebe-b8f1-5c7bdde21deb";
      fsType = "ext4";
      label = "nixos";
      noCheck = false;
      mountPoint = "/";
      neededForBoot = true;
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/79C3-9AB6";
      fsType = "vfat";
      label = "BOOT";
      noCheck = false;
      mountPoint = "/boot";
      neededForBoot = true;
    };
  };
}
