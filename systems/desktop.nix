{
  pkgs,
  settings,
  lib,
  ...
}: {
  imports = let
    modules = [
      "boot"
      "dwm"
      "fonts"
      "git"
      "packages"
      "parrot"
      "picom"
      "refreshrate"
      "shells"
      "sxhkd"
      "theme"
      "vfio"
      "spicetify"
      #"mining"
    ];
  in
    lib.lists.forEach modules (
      m:
        ../modules + ("/" + m + ".nix")
    );
  environment.systemPackages = with pkgs; [
    webcord # talk to people (gross)
    bitwarden #store stuff
    qbittorrent #steal stuff
    networkmanagerapplet #gui connection control
    vlc #play stuff
    dmenu #suckless launcher
  ];
  networking.hostName = settings.hostname;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.cpu.amd.updateMicrocode = true;
  #user managment
  users = {
    defaultUserShell = pkgs.zsh;
    users."${settings.username}" = {
      uid = 1000;
      isNormalUser = true;
      extraGroups = ["wheel" "audio" "networkmanager" "kvm" "libvirtd"];
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
