{
  inputs = {
    #channels
    master.url = "github:nixos/nixpkgs";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-22.11";
    pipewire_fix.url = "github:nixos/nixpkgs/45a55711fe12d0aada3aa04746082cf1b83dfbf3";
    #nix 2.16
    nix.url = "github:nixos/nix/03f9ff6ea59d21c6d7b29c64a03d5041bd621261";

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
    #the-argus is awesome
    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "unstable";
    };
    #my own packages
    suckless = {
      url = "github:gerg-L/suckless";
      inputs.nixpkgs.follows = "unstable";
    };
    nvim-flake = {
      url = "github:gerg-L/nvim-flake";
      inputs.nixpkgs.follows = "unstable";
    };
    fetch-rs = {
      url = "github:gerg-L/fetch-rs";
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
        name: (import (self + "/systems/" + name + "/disko.nix") {inherit inputs;})
      );

    withSystem = f:
      lib.fold lib.recursiveUpdate {}
      (map (s: f s) ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"]);
  in
    withSystem (
      system: let
        pkgs = unstable.legacyPackages.${system};
      in {
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
        formatter.${system} = pkgs.alejandra;

        devShells.${system}.default = pkgs.mkShell {
          packages = [
            pkgs.sops
          ];
        };

        packages.${system} =
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
