{
  inputs,
  lib,
  ...
}: {
  environment.etc = {
    "nix/flake-channels/system".source = inputs.self;
    "nix/flake-channels/nixpkgs".source = inputs.nixpkgs.outPath;
    "nix/flake-channels/home-manager".source = inputs.home-manager.outPath;
  };
  nix = {
    nixPath = [
      "nixpkgs=/etc/nix/flake-channels/nixpkgs"
      "home-manager=/etc/nix/flake-channels/home-manager"
    ];
    #automatically get registry from input flakes
    registry =
      {
        system.flake = inputs.self;
        default.flake = inputs.nixpkgs;
      }
      // lib.attrsets.mapAttrs (
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
  };
}
