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
      ../modules/xserver.nix
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
  
# user managment
  users = {
    defaultUserShell = pkgs.zsh;
    users.gerg = {
      isNormalUser = true;
      extraGroups = [ "wheel" "audio" "networkmanager" "kvm" "libvirtd" ];
    };
  };
}

