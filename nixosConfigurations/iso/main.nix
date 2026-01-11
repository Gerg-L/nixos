{
  disko,
  nixos-generators,
  lib,
  modulesPath,
  pkgs,
}:
{
  ##Build wtih nix build .#nixosConfigurations.iso.config.formats.iso
  local = {
    hardware = {
      gpuAcceleration.disable = true;
      sound.disable = true;
    };
    bootConfig = {
      disable = true;
    };
  };
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    nixos-generators.nixosModules.all-formats
  ];
  documentation = {
    enable = lib.mkForce false;
    man.enable = lib.mkForce false;
    doc.enable = lib.mkForce false;
    info.enable = lib.mkForce false;
    nixos.enable = lib.mkForce false;
  };

  installer.cloneConfig = lib.mkForce false;

  environment.systemPackages = [
    pkgs.neovim
    disko.packages.default
  ];
  image.fileName = lib.mkForce "NixOS";

  isoImage = {
    edition = lib.mkForce "gerg-minimal";
  };

  system.stateVersion = "24.11";
  networking.hostName = "gerg-iso";
  nixpkgs.hostPlatform = "x86_64-linux";
}
