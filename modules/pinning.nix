inputs: {lib, ...}: let
  alias = inputs // {nixpkgs = inputs.unstable;};
in
  lib.pipe alias [
    (lib.filterAttrs (_: v: v._type == "flake"))
    (lib.mapAttrsToList (n: input: {
      nix.nixPath = ["${n}=flake:${n}"];
      nix.registry.${n}.flake = input;
    }))
    lib.mkMerge
  ]
