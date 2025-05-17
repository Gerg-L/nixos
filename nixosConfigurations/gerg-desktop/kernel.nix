{
  lib,
  pkgs,
  config,
}:
{

  boot.kernelPackages = pkgs.linuxPackagesFor (
    let
      version = "6.14.5";
      src = pkgs.fetchurl {
        url = "mirror://kernel/linux/kernel/v${builtins.head (lib.splitVersion version)}.x/linux-${version}.tar.xz";
        hash = "sha256-KCB+xSu+qjUHAQrv+UT0QvfZ8isoa3nK9F7G3xsk9Ak=";
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
}
