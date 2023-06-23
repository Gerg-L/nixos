inputs: {lib, ...}: let
  alias = inputs // {nixpkgs = inputs.unstable;};
in
  lib.pipe alias [
    (lib.filterAttrs (_: v: v._type == "flake"))
    (lib.mapAttrsToList (n: input: {
      environment.etc."nixpath/${n}".source = input.outPath;
      nix.nixPath = ["${n}=/etc/nixpath/${n}"];
      nix.registry.${n}.flake = input;
    }))
    lib.mkMerge
  ]
