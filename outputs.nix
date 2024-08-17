inputs@{ self, unstable, ... }:
let
  lib = import ./lib inputs;
in
lib.gerg-utils (s: unstable.legacyPackages.${s}) {
  inherit lib;
  nixosConfigurations = lib.mkHosts "${self}/hosts";

  nixosModules = lib.mkModules "${self}/modules";

  diskoConfigurations = lib.mkDisko "${self}/disko";

  formatter = pkgs: inputs.self.packages.${pkgs.stdenv.system}.lint;

  devShells = pkgs: { default = pkgs.mkShellNoCC { packages = [ pkgs.sops ]; }; };

  packages = lib.mkPackages "${self}/packages";
}
