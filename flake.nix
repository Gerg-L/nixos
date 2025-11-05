{
  inputs = {
    #nixpkgs refs
    master = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "master";
    };
    unstable = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };
    stable = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-25.05";
    };
    #nix itself
    nix = {
      type = "github";
      owner = "NixOS";
      repo = "nix";
      ref = "d035d8ba8d85cb09517431e4da0d819475e84d7b";
      inputs.nixpkgs.follows = "stable";
    };
    #other
    nixos-generators = {
      type = "github";
      owner = "nix-community";
      repo = "nixos-generators";
      inputs.nixpkgs.follows = "unstable";
    };
    sops-nix = {
      type = "github";
      owner = "mic92";
      repo = "sops-nix";
      inputs.nixpkgs.follows = "unstable";
    };
    disko = {
      type = "github";
      owner = "nix-community";
      repo = "disko";
      inputs.nixpkgs.follows = "unstable";
    };
    nix-index-database = {
      type = "github";
      owner = "nix-community";
      repo = "nix-index-database";
      inputs.nixpkgs.follows = "unstable";
    };
    lanzaboote = {
      type = "github";
      owner = "nix-community";
      repo = "lanzaboote";
      inputs.nixpkgs.follows = "unstable";
    };
    systems = {
      type = "github";
      owner = "nix-systems";
      repo = "default";
    };
    #my own packages
    spicetify-nix = {
      type = "github";
      owner = "Gerg-L";
      repo = "spicetify-nix";
      inputs.nixpkgs.follows = "unstable";
    };
    suckless = {
      type = "github";
      owner = "Gerg-L";
      repo = "suckless";
      inputs.nixpkgs.follows = "unstable";
    };
    nvim-flake = {
      type = "github";
      owner = "Gerg-L";
      repo = "nvim-flake";
      inputs.nixpkgs.follows = "unstable";
    };
    fetch-rs = {
      type = "github";
      owner = "Gerg-L";
      repo = "fetch-rs";
      inputs.nixpkgs.follows = "unstable";
    };
  };
  outputs =
    inputs:
    let
      inherit (inputs.unstable) lib;
      myLib = import (./. + /lib/_default.nix) inputs;
    in
    lib.pipe ./. [
      builtins.readDir
      (lib.filterAttrs (n: v: v == "directory" && !lib.hasPrefix "." n))
      (lib.flip (
        system:
        (builtins.mapAttrs (
          n: _:
          let
            imported = import (./. + "/${n}/_default.nix");
          in
          if myLib.needsSystem n then
            {
              ${system} = imported {
                inputs' = myLib.constructInputs' system inputs;
                inherit system;
              };
            }
          else
            imported inputs
        ))
      ))
      (lib.flip map (import inputs.systems))
      (lib.foldAttrs (l: r: if myLib.needsSystem l then l else l // r) { })
    ];
}
