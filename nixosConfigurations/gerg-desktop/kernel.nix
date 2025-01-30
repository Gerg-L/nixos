{
  lib,
  pkgs,
  config,
}:
{

  boot = {
    # For linuxManualConfig to work: https://github.com/NixOS/nixpkgs/issues/368249
    initrd.systemd.strip = false;

    kernelPackages = pkgs.linuxPackagesFor (
      let
        version = "6.12.11";
        src = pkgs.fetchurl {
          url = "mirror://kernel/linux/kernel/v${builtins.head (lib.splitVersion version)}.x/linux-${version}.tar.xz";
          hash = "sha256-R1Fy/b2HoVPxI6V5Umcudzvbba9bWKQX0aXkGfz+7Ek=";
        };
      in
      (pkgs.linuxManualConfig {
        inherit src;
        inherit (config.boot) kernelPatches;
        version = "${version}-gerg";
        config = {
          CONFIG_RUST = "y";
          CONFIG_MODULES = "y";
        };
        configfile = ./kernelConfig;
      }).overrideAttrs
        (old: {
          passthru = old.passthru or { } // {
            features = lib.foldr (x: y: x.features or { } // y) {
              efiBootStub = true;
              netfilterRPFilter = true;
              ia32Emulation = true;
            } config.boot.kernelPatches;
          };
          meta = old.meta or { } // {
            broken = false;
          };
        })
    );
  };
}
