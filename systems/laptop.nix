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
      ../modules/xserver.nix
      ../modules/zsh.nix
    ];
  networking.hostName = "gerg-laptop";
  boot.kernelPackages = pkgs.linuxPackages_5_18;
  hardware.cpu.amd.updateMicrocode = true;  
  
  # end important stuff
  environment.systemPackages = with pkgs; [
    xorg.xf86videoamdgpu
  ];
# user managment
  users = {
    defaultUserShell = pkgs.zsh;
    users.gerg = {
      isNormalUser = true;
      extraGroups = [ "wheel" "audio" "networkmanager"];
    };
  };
}

