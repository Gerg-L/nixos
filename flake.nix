{
  inputs = {
    #channels
    master.url = "github:NixOS/nixpkgs";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    stable.url = "github:NixOS/nixpkgs/nixos-22.11";
    #nix 2.16
    nix.url = "github:NixOS/nix/latest-release";

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
    mkDisko = names:
      lib.genAttrs names (
        name: (import (self + "/systems/" + name + "/disko.nix") inputs)
      );

    withSystem = attrSet: let
      f = attrPath:
        lib.zipAttrsWith (
          n: values:
            if lib.tail values == []
            then lib.head values
            else if lib.all lib.isList values
            then lib.unique (lib.concatLists values)
            else if lib.all lib.isAttrs values
            then f (attrPath ++ [n]) values
            else lib.last values
        );
    in
      f [] (map (system: attrSet system) ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"]);
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
      diskoConfigurations =
        mkDisko
        [
          "gerg-desktop"
          "game-laptop"
          "moms-laptop"
        ];
    }
    // withSystem (
      system: let
        pkgs = unstable.legacyPackages.${system};
      in {
        formatter.${system} = pkgs.alejandra;

        devShells.${system}.default = pkgs.mkShell {
          packages = [
            pkgs.sops
            pkgs.nil
            pkgs.alejandra
            pkgs.deadnix
            pkgs.statix
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
