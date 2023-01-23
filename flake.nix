{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    suckless = {
      url = "github:ISnortPennies/suckless";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    spicetify-nix,
    suckless,
    ...
  } @ inputs: let
    username = "gerg";
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        packageOverrides = super: let
          self = super.pkgs;
        in {
          nerdfonts-overpass = self.nerdfonts.override {
            fonts = ["Overpass"];
          };
        };
      };
      overlays = [
        (final: prev: rec {
          t-rex-miner = final.callPackage ./pkgs/t-rex-miner {};
          afk-cmds = final.callPackage ./pkgs/afk-cmds {};
          parrot = final.callPackage ./pkgs/parrot {};
          discord = prev.discord.override {
            withOpenASAR = true;
            nss = prev.nss_latest;
          };
        })
        suckless.overlays.all
      ];
    };
    lib = nixpkgs.lib;
  in {
    formatter.x86_64-linux = pkgs.alejandra;

    nixosConfigurations = {
      gerg-desktop = lib.nixosSystem {
        inherit system pkgs;
        specialArgs = {inherit inputs username;};
        modules = [
          ./configuration.nix
          ./systems/desktop.nix
          {
            environment.etc = {
              "nix/inputs/nixpkgs".source = inputs.nixpkgs.outPath;
              "nix/inputs/home-manager".source = inputs.home-manager.outPath;
            };
            nix = {
              nixPath = [
                "nixpkgs=/etc/nix/inputs/nixpkgs"
                "home-manager=/etc/nix/inputs/home-manager"
              ];
              registry = {
                nixpkgs.flake = nixpkgs;
                suckless.flake = suckless;
              };
            };
          }
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = false;
              extraSpecialArgs = {inherit spicetify-nix username;};
              users = {
                ${username} = import ./home-manager/home.nix;
                root = import ./home-manager/root.nix;
              };
            };
          }
        ];
      };
    };
  };
}
