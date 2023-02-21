_: {
  lib,
  modulesPath,
  ...
}: {
  imports = [
    "${toString modulesPath}/profiles/minimal.nix"
    "${toString modulesPath}/installer/cd-dvd/installation-cd-base.nix"
  ];

  # Causes a lot of uncached builds for a negligible decrease in size.
  environment.noXlibs = lib.mkOverride 500 false;

  documentation.man.enable = lib.mkOverride 500 true;

  # Although we don't really need HTML documentation in the minimal installer,
  # not including it may cause annoying cache misses in the case of the NixOS manual.
  documentation.doc.enable = lib.mkOverride 500 true;

  fonts.fontconfig.enable = lib.mkForce false;

  isoImage = {
    edition = lib.mkForce "gerg-minimal";

    isoName = lib.mkForce "NixOS.iso";
  };

}
