{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs";
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
    nvim-config = {
      url = "github:ISnortPennies/nvim-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    nixpkgs-master,
    home-manager,
    spicetify-nix,
    suckless,
    ...
  } @ inputs: let
    settings = {
      username = "gerg";
      version = "23.05";
    };
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        (final: prev: rec {
          t-rex-miner = final.callPackage ./pkgs/t-rex-miner {};
          afk-cmds = final.callPackage ./pkgs/afk-cmds {};
          parrot = final.callPackage ./pkgs/parrot {};
          webcord = inputs.nixpkgs-master.legacyPackages.${system}.webcord;
          nerdfonts-overpass = prev.nerdfonts.override {
            fonts = ["Overpass"];
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
        specialArgs = {inherit inputs settings;};
        modules = [
          ./configuration.nix
          ./systems/desktop.nix
          {
            environment.etc = {
              "nix/flake-channels/system".source = inputs.self;
              "nix/flake-channels/nixpkgs".source = inputs.nixpkgs.outPath;
              "nix/flake-channels/home-manager".source = inputs.home-manager.outPath;
            };
            nix = {
              nixPath = [
                "nixpkgs=/etc/nix/flake-channels/nixpkgs"
                "home-manager=/etc/nix/flake-channels/home-manager"
              ];
              #automatically get registry from input flakes
              registry =
                {
                  system.flake = self;
                  default.flake = nixpkgs;
                }
                // lib.attrsets.mapAttrs (
                  _: source: {
                    flake = source;
                  }
                ) (
                  lib.attrsets.filterAttrs (
                    _: source: (
                      !(lib.attrsets.hasAttrByPath ["flake"] source) || source.flake == false
                    )
                  )
                  inputs
                );
              settings = {
                experimental-features = ["nix-command" "flakes" "repl-flake"];
                auto-optimise-store = true;
                warn-dirty = false;
              };
            };
          }
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = false;
              extraSpecialArgs = {inherit spicetify-nix settings;};
              users = {
                ${settings.username} = import ./home-manager/home.nix;
                root = import ./home-manager/root.nix;
              };
            };
          }
        ];
      };
    };
  };
}
