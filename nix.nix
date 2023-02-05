{
  inputs,
  lib,
  config,
  ...
}: {
  environment.etc = {
    "nix/flake-channels/system".source = inputs.self;
    "nix/flake-channels/nixpkgs".source = inputs.nixpkgs.outPath;
  };
  nix = {
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    #automatically get registry from input flakes
    registry =
      lib.attrsets.mapAttrs (
        _: source: {
          flake = source;
        }
      ) (
        lib.attrsets.filterAttrs (
          _: source: (
            !(lib.attrsets.hasAttrByPath ["flake"] source) || source.flake == false
          )
        )
        inputs
      );
    settings = {
      experimental-features = ["nix-command" "flakes" "repl-flake"];
      auto-optimise-store = true;
      warn-dirty = false;
    };
    extraOptions = ''
      keep-outputs = false
      keep-derivations = false
    '';
  };
}
