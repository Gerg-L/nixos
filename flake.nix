{
  description = "testing";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixkpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";
  };

  outputs = { nixpkgs, home-manager, nur, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        packageOverrides = super: let self = super.pkgs; in {
          #more overrides can go here
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
        inherit pkgs;
        modules = [
          nur.nixosModules.nur
          ./home-manager.nix
        ];
      };
    };
    nixosConfigurations = {
      gerg-laptop = lib.nixosSystem { 
        inherit system pkgs;
        modules = [
          nur.nixosModules.nur
          ./configuration.nix
        ];
      };
    };
  };
}
