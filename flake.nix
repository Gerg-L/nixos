{
  inputs = {
    #channels
    master.url = "github:nixos/nixpkgs";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-23.05";
    pipewire_fix.url = "github:nixos/nixpkgs/45a55711fe12d0aada3aa04746082cf1b83dfbf3";
    #nix 2.17
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
    spicetify-nix = {
      #url = "github:the-argus/spicetify-nix";
      url = "path:/home/gerg/Projects/spicetify-nix";
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
    unstable,
    nixos-generators,
    ...
  }: let
    lib = import ./lib inputs;
  in
    lib.withSystem (
      system: let
        pkgs = unstable.legacyPackages.${system};
      in {
        inherit lib;
        nixosConfigurations =
          lib.mkSystems
          "x86_64-linux"
          [
            "gerg-desktop"
            "game-laptop"
            "moms-laptop"
          ];

        nixosModules = lib.mkModules ./modules;

        diskoConfigurations =
          lib.mkDisko
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
          // lib.mkPkgs pkgs ./pkgs;
      }
    );
}
