{
  inputs = {
    #channels
    master.url = "github:NixOS/nixpkgs";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    stable.url = "github:NixOS/nixpkgs/nixos-22.11";
    #utilites --maybe flake-parts soon?
    flake-utils.url = "github:numtide/flake-utils";

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
      inputs.nixpkgs.follows = "master";
    };
    fetch-rs = {
      url = "github:Gerg-L/fetch-rs";
      inputs.nixpkgs.follows = "unstable";
    };
  };
  outputs = {
    self,
    unstable,
    stable,
    flake-utils,
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
            (import ./systems/desktop.nix inputs)
            {
              nixpkgs.overlays = [
                (import ./pkgs)
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
            (import ./systems/laptop.nix inputs)
          ];
        };
        moms-laptop = stable.lib.nixosSystem {
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
            (import ./systems/mom.nix inputs)
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
      }
    );
}
