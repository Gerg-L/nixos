{
  lib,
  pkgs,
  config,
}:
{

  boot.kernelPackages = pkgs.linuxPackagesFor (
    let
      version = "6.19.5";
      src = pkgs.fetchurl {
        url = "mirror://kernel/linux/kernel/v${builtins.head (lib.splitVersion version)}.x/linux-${version}.tar.xz";
        hash = "sha256-la4FyMcJ41PA6FBsBy78VZjYW4t7Vkoeusfug0UEL/o=";
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
