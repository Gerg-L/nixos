{
  description = "testing";
  inputs = {
    nixpkgs.url = "nixpkgs/master";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixkpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }:
  let
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
    };
    lib = nixpkgs.lib;
  in {
    homeManagerConfiguration = {
      gerg = home-manager.lib.homeManagerConfiguration {
        inherit system pkgs;
        username = "gerg";
        homeDirectory = "/home/gerg";
        configuration = {
          imports = [
            ./home-manager.nix
          ];
        };
      };
    };
    nixosConfigurations = {
      gerg-laptop = lib.nixosSystem { 
        inherit system pkgs;
        modules = [
          ./configuration.nix
        ];
      };
    };
  };
}
