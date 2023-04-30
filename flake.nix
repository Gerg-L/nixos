{
  inputs = {
    #channels
    master.url = "github:NixOS/nixpkgs";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    stable.url = "github:NixOS/nixpkgs/nixos-22.11";
    #nix 2.16
    nix.url = "github:NixOS/nix/946fd29422361e8478425d6aaf9ccae23d7ddffb";
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
    nixos-generators,
    ...
  }: let
    lib = unstable.lib;

    importAll = path:
      map
      (module: (import module inputs))
      (
        builtins.filter (file: lib.hasSuffix ".nix" file)
        (lib.filesystem.listFilesRecursive path)
      );

    mkSystems = system: names:
      lib.genAttrs names (
        name:
          lib.nixosSystem {
            inherit system;
            specialArgs = {inherit self;};
            modules =
              importAll ./modules
              ++ importAll (self + "/systems/" + name);
          }
      );
  in
    {
      nixosConfigurations =
        mkSystems
        "x86_64-linux"
        [
          "gerg-desktop"
          "game-laptop"
          "moms-laptop"
        ];
    }
    // flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import unstable {inherit system;};
      in {
        formatter = pkgs.alejandra;
        devShells = {
          default = pkgs.mkShell {
            packages = [
              pkgs.sops
              pkgs.nil
              pkgs.alejandra
              pkgs.deadnix
              pkgs.statix
            ];
          };
        };
        packages =
          {
            nixos-iso = nixos-generators.nixosGenerate {
              inherit system;
              format = "install-iso";
              modules = [
                (import ./installer inputs)
              ];
            };
          }
          // builtins.listToAttrs (
            map (module: {
              name = lib.removeSuffix ".nix" (builtins.baseNameOf module);
              value = pkgs.callPackage module {};
            })
            (
              builtins.filter (file: lib.hasSuffix ".nix" file)
              (lib.filesystem.listFilesRecursive ./pkgs)
            )
          );
      }
    );
}
