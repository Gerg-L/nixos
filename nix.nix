{
  nix,
  unstable,
  ...
}: {
  inputs,
  lib,
  pkgs,
  self,
  ...
}: {
  nix = {
    package = nix.packages.${pkgs.system}.nix;
    #automatically get registry from input flakes
    registry =
      (
        lib.attrsets.mapAttrs (
          _: value: {
            flake = value;
          }
        ) (
          lib.attrsets.filterAttrs (
            _: value: (
              !(lib.attrsets.hasAttrByPath ["flake"] value) || value.flake == false
            )
          )
          inputs
        )
      )
      // {system = {flake = self;};};
    #automatically add registry entries to nixPath
    nixPath = (lib.mapAttrsToList (name: value: name + "=" + value) inputs) ++ ["system=${self}" "nixpkgs=${unstable}"];
    settings = {
      experimental-features = ["nix-command" "flakes" "repl-flake"];
      auto-optimise-store = true;
      warn-dirty = false;
      flake-registry = builtins.toFile "empty-flake-registry.json" ''{"flakes":[],"version":2}'';
      keep-outputs = true;
      keep-derivations = true;
       trusted-users = [
        "root"
        "@wheel"
      ];
      allowed-users = [
      ];
    };
  };
  environment.etc."booted-system".source = self;
}
