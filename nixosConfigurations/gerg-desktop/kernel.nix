{
  lib,
  pkgs,
  config,
}:
{

  boot.kernelPackages = pkgs.linuxPackagesFor (
    let
      version = "7.0.14";
      src = pkgs.fetchurl {
        url = "mirror://kernel/linux/kernel/v${builtins.head (lib.splitVersion version)}.x/linux-${version}.tar.xz";
        hash = "sha256-3pmZt4TSKT8A05xi2PkqCKuKVLxOgP/SUKDAnLB6D5g=";
      };
    in
    (pkgs.linuxManualConfig {
      inherit src;
      inherit (config.boot) kernelPatches;
      version = "${version}-gerg";
      config = pkgs.linuxPackages_latest.kernel.config;
      configfile = ./kernelConfig;
    }).overrideAttrs
      (old: {
        passthru = old.passthru or { } // {
          features = builtins.foldl' (
            x: y: x.features or { } // y
          ) pkgs.linuxPackages_latest.kernel.features config.boot.kernelPatches;
        };
      })
  );
}
