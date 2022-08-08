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
      ../modules/misc.nix
      ../modules/vfio.nix
      ../modules/refreshrate.nix
      ../modules/xserver.nix
      ../modules/smb.nix
    ];
  networking.hostName = "gerg-desktop";
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  system.stateVersion = "22.11";
  hardware.cpu.amd.updateMicrocode = true;  
  # end important stuff
  environment.systemPackages = with pkgs; [
    android-tools
    openjdk
  ];
# user managment
  users = {
    defaultUserShell = pkgs.dash;
    users.gerg = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "audio" "networkmanager" "kvm" "libvirtd" ];
    };
  };
}

