{
  inputs = {
    #channels
    master.url = "github:NixOS/nixpkgs";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    stable.url = "github:NixOS/nixpkgs/nixos-22.11";
    #nix 2.16
    nix.url = "github:NixOS/nix/b41f73906896b02b8ffa3f9ea4ea8a18a61a34e0";
    #utilites
    flake-utils.url = "github:numtide/flake-utils";
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
    nvim-flake = {
      url = "github:Gerg-L/nvim-flake";
      inputs.nixpkgs.follows = "unstable";
    };
    fetch-rs = {
      url = "github:Gerg-L/fetch-rs";
      inputs.nixpkgs.follows = "unstable";
    };
  };
  outputs = inputs @ {
    self,
    unstable,
    flake-utils,
    nvim-flake,
    nixos-generators,
    ...
  }:
    {
      nixosConfigurations = {
        gerg-desktop = unstable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit self;
            settings = {
              username = "gerg";
            };
          };
          modules = [
            (import ./modules inputs)
            (import ./systems/gerg-desktop inputs)
            {
              nixpkgs.overlays = [
                nvim-flake.overlays.default
              ];
            }
          ];
        };
        game-laptop = unstable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit self;
            settings = {
              username = "games";
            };
          };
          modules = [
            (import ./modules inputs)
            (import ./systems/game-laptop inputs)
          ];
        };
        moms-laptop = unstable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit self;
            settings = {
              username = "jo";
            };
          };
          modules = [
            (import ./modules inputs)
            (import ./systems/moms-laptop inputs)
          ];
        };
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import unstable {inherit system;};
      in {
        formatter = pkgs.alejandra;
        devShells = rec {
          nix = pkgs.mkShell {
            packages = [
              pkgs.sops
              pkgs.nil
              pkgs.alejandra
              pkgs.deadnix
              pkgs.statix
            ];
          };
          default = nix;
        };
        packages =
          {
            nixos-iso = nixos-generators.nixosGenerate {
              inherit system;
              format = "install-iso";
              modules = [
                (import ./pkgs/nixos-iso inputs)
              ];
            };
          }
          // (import ./pkgs pkgs);
      }
    );
}
