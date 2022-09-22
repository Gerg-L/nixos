{
  description = "my personal configurations";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable"; 
    home-manager = {
      url = "github:ISnortPennies/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix.url = "github:the-argus/spicetify-nix";
    webcord.url = "github:fufexan/webcord-flake";
  };

  outputs = {self, nixpkgs, home-manager, spicetify-nix, webcord, ... }@inputs:
    let
    username = "gerg";
  system = "x86_64-linux";
  pkgs = import nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
      packageOverrides = super: let self = super.pkgs; in {
        nerdfonts-overpass = self.nerdfonts.override {
          fonts = [ "Overpass" ];
        };
      };
    };
    overlays = [
      (final: prev: rec {
       t-rex-miner = final.callPackage ./pkgs/t-rex-miner {};
       afk-cmds = final.callPackage ./pkgs/afk-cmds {};
       }
      )
      (import ./suckless)
      (self: super:
        let
          vim-moonfly = super.vimUtils.buildVimPlugin {
            name = "vim-moonfly";
            src = pkgs.fetchFromGitHub {
              owner = "bluz71";
              repo = "vim-moonfly-colors";
              rev = "065c99b95355b33dfaa05bde11ad758e519b04a3";
              sha256 = "sha256-TEYN8G/VNxitpPJPM7+O9AGLm6V7bPkiTlFG5op55pI=";
            };
          };
        in {
          vimPlugins =
            super.vimPlugins // { inherit vim-moonfly; };
          }
      )
    ];
  };
  lib = nixpkgs.lib;
  in {
    homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ./home-manager/home.nix
      ];
      extraSpecialArgs = { inherit spicetify-nix; };
    };
    homeConfigurations.root = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ./home-manager/root.nix
      ];
    };
    nixosConfigurations = {
      gerg-laptop = lib.nixosSystem { 
        inherit system pkgs;
        specialArgs = inputs;
        modules = [
          ./configuration.nix
            ./systems/laptop.nix
        ];
      };
      gerg-desktop = lib.nixosSystem { 
        inherit system pkgs;
        specialArgs = inputs;
        modules = [
          ./configuration.nix
            ./systems/desktop.nix
        ];
      };
    };
  };
}
