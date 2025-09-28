{
  lib,
  pkgs,
  config,
}:
{

  boot.kernelPackages = pkgs.linuxPackagesFor (
    let
      version = "6.16.9";
      src = pkgs.fetchurl {
        url = "mirror://kernel/linux/kernel/v${builtins.head (lib.splitVersion version)}.x/linux-${version}.tar.xz";
        hash = "sha256-esjIo88FR2N13qqoXfzuCVqCb/5Ve0N/Q3dPw7ZM5Y0=";
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
      extraMeta = {
        broken = false;
      };
    }).overrideAttrs
      (old: {
        passthru = old.passthru or { } // {
          features = lib.foldr (x: y: x.features or { } // y) {
            efiBootStub = true;
            netfilterRPFilter = true;
            ia32Emulation = true;
          } config.boot.kernelPatches;
        };
      })
  );
}
