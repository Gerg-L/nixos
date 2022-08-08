{ config, pkgs, callPackage, lib, ... }:
{
  #important stuff first
  imports =
    [
      ../modules/boot.nix
      ../modules/prime.nix
      ../modules/nvidia.nix
      ../modules/packages.nix
      ../modules/fonts.nix
      ../modules/thunar.nix
      ../modules/scripts.nix
      ../modules/misc.nix
      ../modules/xserver.nix
    ];
  networking.hostName = "gerg-laptop";
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
    xorg.xf86videoamdgpu
  ];
  
# user managment
  users = {
    defaultUserShell = pkgs.dash;
    users.gerg = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "audio" "networkmanager"];
    };
  };
}

