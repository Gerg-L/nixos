{
  inputs = {
    #channels
    master.url = "github:NixOS/nixpkgs";
    unstable.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    stable.url = "github:NixOS/nixpkgs?ref=nixos-23.05";

    nix = {
      url = "github:NixOS/nix?ref=2.17-maintenance";
      inputs.nixpkgs.follows = "unstable";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "unstable";
    };
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "unstable";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "unstable";
    };
    nixfmt = {
      url = "github:piegamesde/nixfmt?ref=rfc101-style";
      inputs.nixpkgs.follows = "unstable";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "unstable";
    };
    #my own packages
    suckless = {
      url = "github:Gerg-L/suckless";
      inputs.nixpkgs.follows = "unstable";
    };
    nvim-flake = {
      url = "github:Gerg-L/nvim-flake";
      inputs.nixpkgs.follows = "unstable";
    };
    fetch-rs = {
      url = "github:Gerg-L/fetch-rs";
      inputs.nixpkgs.follows = "unstable";
    };
  };

  outputs =
    inputs:
    let
      lib = import ./lib inputs;
    in
    lib.gerg-utils { allowUnfree = true; } (
      { pkgs, system, ... }:
      {
        inherit lib;
        nixosConfigurations = lib.mkHosts "x86_64-linux" [
          "gerg-desktop"
          "game-laptop"
          "moms-laptop"
          "iso"
        ];

        nixosModules = lib.mkModules ./modules;

        diskoConfigurations = lib.mkDisko [
          "gerg-desktop"
          "game-laptop"
          "moms-laptop"
        ];
        formatter.${system} = pkgs.writeShellApplication {
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

        devShells.${system}.default = pkgs.mkShell { packages = [ pkgs.sops ]; };

        packages.${system} = lib.mkPackages ./packages pkgs;
      }
    );
}
