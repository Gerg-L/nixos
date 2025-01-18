{ inputs', ... }:
let
  inherit (inputs'.unstable) lib;
  pkgs = inputs'.unstable.legacyPackages;
in
lib.pipe ./. [
  builtins.readDir
  builtins.attrNames
  (builtins.filter (x: x != "_default.nix"))
  (map (
    x:
    let
      fullPath = ./. + "/${x}";
    in
    {
      ${lib.removeSuffix ".nix" x} = lib.callPackageWith (
        pkgs
        // pkgs.xorg
        // {
          inherit inputs';
          self' = inputs'.self;
          # npins sources if i ever use them
          # sources = lib.mapAttrs (_: pkgs.npins.mkSource) (lib.importJSON "${self}/packages/sources.json").pins;
        }
      ) fullPath { };
    }
  ))

  lib.mergeAttrsList
]
