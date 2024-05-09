inputs@{ self, ... }:
let
  lib = import ./lib inputs;
in
lib.gerg-utils { } {
  inherit lib;
  nixosConfigurations = lib.mkHosts "x86_64-linux" [
    "gerg-desktop"
    "game-desktop"
    "media-laptop"
    "iso"
  ];

  nixosModules = lib.mkModules "${self}/modules";

  diskoConfigurations = lib.mkDisko [
    "gerg-desktop"
    "game-desktop"
    "media-laptop"
  ];

  formatter = pkgs: inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.lint;

  devShells = pkgs: { default = pkgs.mkShell { packages = [ pkgs.sops ]; }; };

  packages = lib.mkPackages "${self}/packages";
}
