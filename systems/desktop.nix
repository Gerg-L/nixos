{
  pkgs,
  settings,
  lib,
  ...
}: {
  imports = let
    modules = [
      "boot"
      "fonts"
      "git"
      #"mining"
      "packages"
      "parrot"
      "picom"
      "refreshrate"
      "scripts"
      "sxhkd"
      "vfio"
      "dwm"
      "shells"
    ];
  in
    lib.lists.forEach modules (
      m:
        ../modules + ("/" + m + ".nix")
    );
  environment.systemPackages = with pkgs; [
    bitwarden #store stuff
    qbittorrent #steal stuff
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
      device = "/dev/disk/by-id/nvme-Samsung_SSD_980_500GB_S64ENJ0R607785J-part2";
      fsType = "ext4";
      label = "nixos";
      noCheck = false;
      mountPoint = "/";
      neededForBoot = true;
    };
    "/boot" = {
      device = "/dev/disk/by-id/nvme-Samsung_SSD_980_500GB_S64ENJ0R607785J-part1";
      fsType = "vfat";
      label = "BOOT";
      noCheck = false;
      mountPoint = "/boot";
      neededForBoot = true;
    };
  };
}
