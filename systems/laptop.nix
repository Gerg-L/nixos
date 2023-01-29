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
      "xserver"
      "zsh"
    ];
  in
    lib.lists.forEach modules (
      m:
        ../modules + ("/" + m + ".nix")
    );
  networking.hostName = "gerg-laptop";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.cpu.amd.updateMicrocode = true;

  #environment.systemPackages = with pkgs; [
  #  xorg.xf86videoamdgpu
  #];
  #don't think i need this^
  # user managment
  users = {
    defaultUserShell = pkgs.zsh;
    users."${settings.username}" = {
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
