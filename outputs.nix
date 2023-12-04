inputs:
let
  lib = import ./lib inputs;
in
lib.gerg-utils {} {
  inherit lib;
  nixosConfigurations = lib.mkHosts "x86_64-linux" [
    "gerg-desktop"
    "game-desktop"
    "media-laptop"
    "iso"
  ];

  nixosModules = lib.mkModules ./modules;

  diskoConfigurations = lib.mkDisko [
    "gerg-desktop"
    "game-desktop"
    "media-laptop"
  ];
  formatter =
    pkgs:
    pkgs.writeShellApplication {
      name = "lint";
      runtimeInputs = [
        (pkgs.nixfmt.overrideAttrs {
          version = "0.6.0-${inputs.nixfmt.shortRev}";

          src = inputs.nixfmt;
        })
        pkgs.deadnix
        pkgs.statix
        pkgs.fd
      ];
      text = ''
        fd '.*\.nix' . -x statix fix -- {} \;
        fd '.*\.nix' . -X deadnix -e -- {} \; -X nixfmt {} \;
      '';
    };

  devShells = pkgs: {default = pkgs.mkShell {packages = [pkgs.sops];};};

  packages = lib.mkPackages ./packages;
}
