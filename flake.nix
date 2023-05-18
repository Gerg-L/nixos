{
  inputs = {
    #channels
    master.url = "github:NixOS/nixpkgs";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    stable.url = "github:NixOS/nixpkgs/nixos-22.11";
    #nix 2.16
    nix.url = "github:NixOS/nix/684e9be8b9356f92b7882d74cba9d146fb71f850";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "unstable";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "unstable";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "unstable";
    };
    #the-argus is awesome
    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "unstable";
    };
    #my own packages
    suckless = {
      url = "github:Gerg-L/suckless";
      inputs.nixpkgs.follows = "unstable";
    };
    nvim-flake.url = "github:Gerg-L/nvim-flake";
    fetch-rs = {
      url = "github:Gerg-L/fetch-rs";
      inputs.nixpkgs.follows = "unstable";
    };
  };
  outputs = inputs @ {
    self,
    unstable,
    nixos-generators,
    ...
  }: let
    inherit (unstable) lib;

    importAll = path:
      builtins.filter (lib.hasSuffix ".nix")
      (lib.filesystem.listFilesRecursive path);

    mkSystems = system: names:
      lib.genAttrs names (
        name:
          lib.nixosSystem {
            inherit system;
            specialArgs = {inherit inputs self;};
            modules =
              importAll ./modules
              ++ importAll (self + "/systems/" + name);
          }
      );
    mkDisko = names:
      lib.genAttrs names (
        name: (import (self + "/systems/" + name + "/disko.nix") inputs)
      );

    withSystem = f:
      lib.foldAttrs lib.mergeAttrs {}
      (map (s: lib.mapAttrs (_: v: {${s} = v;}) (f s))
        ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"]);
  in
    {
      nixosConfigurations =
        mkSystems
        "x86_64-linux"
        [
          "gerg-desktop"
          "game-laptop"
          "moms-laptop"
        ];
      diskoConfigurations =
        mkDisko
        [
          "gerg-desktop"
          "game-laptop"
          "moms-laptop"
        ];
    }
    // withSystem (
      system: let
        pkgs = unstable.legacyPackages.${system};
      in {
        formatter = pkgs.alejandra;

        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.sops
            pkgs.nil
            pkgs.alejandra
            pkgs.deadnix
            pkgs.statix
          ];
        };

        packages =
          {
            nixos-iso = nixos-generators.nixosGenerate {
              inherit system;
              format = "install-iso";
              modules = [
                (import ./installer inputs)
              ];
            };
          }
          // builtins.listToAttrs (
            map (module: {
              name = lib.removeSuffix ".nix" (builtins.baseNameOf module);
              value = pkgs.callPackage module {};
            })
            (
              builtins.filter (lib.hasSuffix ".nix")
              (lib.filesystem.listFilesRecursive ./pkgs)
            )
          );
      }
    );
}
