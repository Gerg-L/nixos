{
  pkgs,
  settings,
  ...
}: {
  #important stuff first
  imports = [
    ../modules/packages.nix
    ../modules/boot.nix
    ../modules/fonts.nix
    ../modules/scripts.nix
    ../modules/vfio.nix
    ../modules/refreshrate.nix
    ../modules/xserver.nix
    ../modules/zsh.nix
    ../modules/git.nix
    #../modules/mining.nix
    ../modules/parrot.nix
  ];
  networking.hostName = "gerg-desktop";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.cpu.amd.updateMicrocode = true;
  #end important stuff
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
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "uas" "sd_mod"];
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/e5c9634f-0273-4fd3-b35f-49899984340f";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/D3B9-197E";
      fsType = "vfat";
    };
  };
}
