inputs: {
  pkgs,
  lib,
  ...
}:
#
# Flake registry and $NIX_PATH pinning
#
let
  alias = inputs // {nixpkgs = inputs.unstable;};
  flakes = lib.filterAttrs (_: v: v._type == "flake") alias;
in {
  nix.nixPath = lib.mapAttrsToList (x: _: "${x}=flake:${x}") flakes;
  nix.registry = lib.mapAttrs (_: flake: {inherit flake;}) flakes;
  #
  # Ignore global registry
  #
  nix.settings.flake-registry = builtins.toFile "empty-flake-registry.json" ''{"flakes":[],"version":2}'';
  #
  # Other nix settings
  #
  nix = {
    package = inputs.nix.packages.${pkgs.system}.default;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "repl-flake"
      ];
      auto-optimise-store = true;
      warn-dirty = false;
      #use for testing
      #allow-import-from-derivation = false;
      trusted-users = [
        "root"
        "@wheel"
      ];
      allowed-users = [];
      use-xdg-base-directories = true;
    };
  };

  #fix for use-xdg-base-directories
  environment.profiles = [
    "\${XDG_STATE_HOME:-$HOME/.local/state}/nix/profile"
  ];
  _file = ./nix.nix;
}
