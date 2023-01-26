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
      "refreshrate"
      "scripts"
      "vfio"
      "xserver"
      "zsh"
    ];
  in
    lib.lists.forEach modules (
      m:
        ../modules + ("/" + m + ".nix")
    );
  networking.hostName = "gerg-desktop";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.cpu.amd.updateMicrocode = true;
  environment.systemPackages = with pkgs; [
    vscodium
    gimp
  ];
  #user managment
  users = {
    defaultUserShell = pkgs.zsh;
    users."${settings.username}" = {
      isNormalUser = true;
      extraGroups = ["wheel" "audio" "networkmanager" "kvm" "libvirtd"];
    };
  };
  boot = {
    initrd = {
      kernelModules = ["amdgpu"];
      availableKernelModules = ["nvme" "ext4" "vfat" "xhci_pci" "ahci" "usbhid" "sd_mod"];
      includeDefaultModules = false;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-id/nvme-Samsung_SSD_980_500GB_S64ENJ0R607785J-part2";
      fsType = "ext4";
      label = "nixos";
    };
    "/boot" = {
      device = "/dev/disk/by-id/nvme-Samsung_SSD_980_500GB_S64ENJ0R607785J-part1";
      fsType = "vfat";
      label = "BOOT";
    };
  };
}
