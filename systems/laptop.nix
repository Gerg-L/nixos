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
      "packages"
      "picom"
      "prime"
      "scripts"
      "sxhkd"
      "xserver"
      "shells"
      "gaming"
    ];
  in
    lib.lists.forEach modules (
      m:
        ../modules + ("/" + m + ".nix")
    );
  networking.hostName = settings.hostname;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.cpu.amd.updateMicrocode = true;
  users = {
    defaultUserShell = pkgs.zsh;
    users."${settings.username}" = {
      uid = 1000;
      isNormalUser = true;
      extraGroups = ["wheel" "audio" "networkmanager"];
    };
  };
  boot = {
    initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci"];
    kernelModules = ["kvm-amd"];
  };
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/c67796b3-d502-47db-8d0e-48f30bc91041";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/AD02-10EA";
      fsType = "vfat";
    };
  };
}
