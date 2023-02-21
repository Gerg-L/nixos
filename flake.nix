{
  inputs = {
    #channels
    master.url = "github:NixOS/nixpkgs";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    stable.url = "github:NixOS/nixpkgs/nixos-22.11";
    #utilites --maybe flake-parts soon?
    flake-utils.url = "github:numtide/flake-utils";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "unstable";
    };

    #master branch of nix
    nix.url = "github:NixOS/nix";

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
  outputs = {
    self,
    unstable,
    flake-utils,
    nvim-flake,
    nixos-generators,
    ...
  } @ inputs:
    {
      nixosConfigurations = {
        gerg-desktop = unstable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs self;
            settings = {
              username = "gerg";
              hostname = "gerg-desktop";
            };
          };

          modules = [
            (import ./modules inputs)
            (import ./common.nix inputs)
            (import ./nix.nix inputs)
            (import ./systems/gerg-desktop inputs)
            {
              nixpkgs.overlays = [
                (import ./pkgs)
                nvim-flake.overlays.default
              ];
            }
          ];
        };
        game-laptop = unstable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs self;
            settings = {
              username = "games";
              hostname = "game-laptop";
            };
          };
          modules = [
            (import ./modules inputs)
            (import ./common.nix inputs)
            (import ./nix.nix inputs)
            (import ./systems/game-laptop inputs)
          ];
        };
        moms-laptop = unstable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs self;
            settings = {
              username = "jo";
              hostname = "moms-laptop";
            };
          };
          modules = [
            (import ./modules inputs)
            (import ./common.nix inputs)
            (import ./nix.nix inputs)
            (import ./systems/mom-laptop inputs)
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
            packages = with pkgs; [nil alejandra deadnix statix];
          };
          rust = pkgs.mkShell {
            packages = with pkgs; [rust-analyzer rustc cargo rustfmt clippy];
          };
          default = nix;
        };
        packages = {
          nixos-iso = nixos-generators.nixosGenerate {
            inherit system;
            format = "install-iso";
            modules = [
              (import ./iso inputs)
            ];
          };
        };
      }
    );
}
