{
  pkgs,
  inputs,
  lib,
  self,
  ...
}: let
  combined_flakes =
    (
      #filter non-flakes from inputs
      lib.filterAttrs (
        _: value: (
          !(lib.hasAttrByPath ["flake"] value) || !value.flake
        )
      )
      inputs
    )
    // {
      #alias unstable
      nixpkgs = inputs.unstable;
      #add system flake
      system = self;
    };
in {
  #create registry from input flakes
  nix.registry = lib.mapAttrs (_: value: {flake = value;}) combined_flakes;
  #add all inputs to etc
  environment.etc = lib.mapAttrs' (name: value: lib.nameValuePair "/nixpath/${name}" {source = value;}) combined_flakes;
  #source the etc paths to nixPath
  nix.nixPath = lib.mapAttrsToList (name: _: name + "=/etc/nixpath/${name}") combined_flakes;

  #other nix settings
  nix = {
    package = inputs.nix.packages.${pkgs.system}.default;
    settings = {
      experimental-features = ["nix-command" "flakes" "repl-flake"];
      auto-optimise-store = true;
      warn-dirty = false;
      #ignore global registry
      flake-registry = builtins.toFile "empty-flake-registry.json" ''{"flakes":[],"version":2}'';
      use-xdg-base-directories = true;
      #use for testing
      #allow-import-from-derivation = false;
      trusted-users = [
        "root"
        "@wheel"
      ];
      allowed-users = [
      ];
    };
  };
}
