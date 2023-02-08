{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    suckless = {
      url = "github:Gerg-L/suckless";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim-config = {
      url = "github:Gerg-L/nvim-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sxhkd-flake = {
      url = "github:Gerg-L/sxhkd-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fetch-rs = {
      url = "github:Gerg-L/fetch-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        (final: _: {
          t-rex-miner = final.callPackage ./pkgs/t-rex-miner {};
          afk-cmds = final.callPackage ./pkgs/afk-cmds {};
          parrot = final.callPackage ./pkgs/parrot {};
        })
        inputs.suckless.overlay
        inputs.nvim-config.overlays.${system}.default
        inputs.fetch-rs.overlays.${system}.default
      ];
    };
  in {
    formatter.x86_64-linux = pkgs.alejandra;
    nixosConfigurations = {
      gerg-desktop = lib.nixosSystem {
        inherit system pkgs;
        specialArgs = {
          inherit inputs self;
          settings = {
            username = "gerg";
            version = "23.05";
            hostname = "gerg-desktop";
          };
        };
        modules = [
          inputs.sxhkd-flake.nixosModules.sxhkd
          ./common.nix
          ./systems/desktop.nix
          ./nix.nix
        ];
      };
      game-laptop = lib.nixosSystem {
        inherit system pkgs;
        specialArgs = {
          inherit inputs self;
          settings = {
            username = "games";
            version = "23.05";
            hostname = "game-laptop";
          };
        };
        modules = [
          ./common.nix
          ./systems/laptop.nix
          ./nix.nix
        ];
      };
      moms-laptop = lib.nixosSystem {
        inherit system pkgs;
        specialArgs = {
          inherit inputs self;
          settings = {
            username = "jo";
            version = "23.05";
            hostname = "moms-laptop";
          };
        };
        modules = [
          ./common.nix
          ./systems/mom.nix
          ./nix.nix
        ];
      };
    };
  };
}
