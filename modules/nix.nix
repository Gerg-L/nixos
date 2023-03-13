inputs: {
  lib,
  pkgs,
  self,
  settings,
  ...
}: let
  combined_flakes =
    (
      #filter non-flakes from inputs
      lib.attrsets.filterAttrs (
        _: value: (
          !(lib.attrsets.hasAttrByPath ["flake"] value) || value.flake == false
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
  nix.registry = lib.attrsets.mapAttrs (_: value: {flake = value;}) combined_flakes;
  #add all inputs to etc
  environment.etc = lib.mapAttrs' (name: value: lib.attrsets.nameValuePair "/nixpath/${name}" {source = value;}) combined_flakes;
  #source the etc paths to nixPath
  nix.nixPath = lib.mapAttrsToList (name: _: name + "=" + "/etc/nixpath/${name}") combined_flakes;

  #other nix settings
  nix = {
    package = pkgs.nixVersions.unstable;
    settings = {
      experimental-features = ["nix-command" "flakes" "repl-flake"];
      auto-optimise-store = true;
      warn-dirty = false;
      #ignore global registry
      flake-registry = builtins.toFile "empty-flake-registry.json" ''{"flakes":[],"version":2}'';
      keep-outputs = true;
      keep-derivations = true;
      use-xdg-base-directories = true;
      trusted-users = [
        "root"
        "@wheel"
      ];
      allowed-users = [
      ];
    };
  };
}
