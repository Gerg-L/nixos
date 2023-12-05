{disko, nixos-generators, ...}:
{
  lib,
  modulesPath,
  pkgs,
  ...
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
    "${modulesPath}/profiles/minimal.nix"
    "${modulesPath}/installer/cd-dvd/installation-cd-base.nix"
    nixos-generators.nixosModules.all-formats
  ];

  environment = {
    noXlibs = lib.mkOverride 500 false;
    systemPackages = [
      pkgs.neovim
      disko.packages.default
    ];
  };
  documentation = {
    man.enable = lib.mkOverride 500 false;
    doc.enable = lib.mkOverride 500 false;
  };

  fonts.fontconfig.enable = lib.mkForce false;

  isoImage = {
    edition = lib.mkForce "gerg-minimal";
    isoName = lib.mkForce "NixOS.iso";
  };

  sound.enable = false;
  #_file
}
