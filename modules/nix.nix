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
  # Use nix directly from master
  #
  nix.package = inputs.nix.packages.${pkgs.system}.default;
  #
  # Other nix settings
  #
  nix.settings = {
    #
    # Ignore global registry
    #
    flake-registry = builtins.toFile "empty-flake-registry.json" ''{"flakes":[],"version":2}'';

    experimental-features = [
      "nix-command"
      "flakes"
      "repl-flake"
    ];
    auto-optimise-store = true;
    warn-dirty = false;
    #
    # Use for testing
    #
    #allow-import-from-derivation = false;
    trusted-users = [
      "root"
      "@wheel"
    ];
    allowed-users = [];
    use-xdg-base-directories = true;
  };
  #
  # Fix for use-xdg-base-directories https://github.com/NixOS/nixpkgs/pull/241518
  #
  environment.profiles = [
    "\${XDG_STATE_HOME:-$HOME/.local/state}/nix/profile"
  ];
  _file = ./nix.nix;
}
