{ config, pkgs, callPackage, lib, ... }:
{
  #important stuff first
  imports =
    [
      ../modules/boot.nix
      ../modules/packages.nix
      ../modules/nvidia.nix
      ../modules/fonts.nix
      ../modules/thunar.nix
      ../modules/scripts.nix
      ../modules/vfio.nix
      ../modules/refreshrate.nix
      ../modules/xserver.nix
      ../modules/smb.nix
      ../modules/zsh.nix
    ];
  networking.hostName = "gerg-desktop";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.cpu.amd.updateMicrocode = true;  
#end important stuff
  environment.systemPackages = with pkgs; [
    afk-cmds
    xmrig
    t-rex-miner
  ];
#user managment
  users = {
    defaultUserShell = pkgs.zsh;
    users.gerg = {
      isNormalUser = true;
      extraGroups = [ "wheel" "audio" "networkmanager" "kvm" "libvirtd" ];
    };
  };
  boot = {
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "uas" "sd_mod" ];
    kernelModules = [ "kvm-amd" "msr"];
    kernelParams = [ "iomem=relaxed" "msr.allow_writes=on" ];
  };
  fileSystems = {
    "/" ={
      device = "/dev/disk/by-uuid/f0f46e34-874f-4052-855c-38c88bd7987a";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/5F00-1D91";
      fsType = "vfat";
    };
  };
  systemd.services.mining = {
    enable = true;
    path = with pkgs; [ afk-cmds t-rex-miner xmrig alacritty zsh ];
    wantedBy = [ "graphical.target" ];
    script = ''
      afk_cmds -c /home/gerg/afk-cmds.json
    '';
    environment = {
      XAUTHORITY="/home/gerg/.Xauthority";
      DISPLAY=":0";
    };
  };
}

