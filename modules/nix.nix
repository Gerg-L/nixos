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
  flakes = lib.filterAttrs (_: lib.isType "flake") alias;
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
      "auto-allocate-uids"
      "ca-derivations"
      "cgroups"
      "daemon-trust-override"
      "dynamic-derivations"
      "fetch-closure"
      "flakes"
      "impure-derivations"
      "nix-command"
      "no-url-literals"
      "parse-toml-timestamps"
      "read-only-local-store"
      "recursive-nix"
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
    auto-allocate-uids = true;
  };
  #
  # Fix for use-xdg-base-directories https://github.com/NixOS/nixpkgs/pull/241518
  #
  environment.profiles = [
    "\${XDG_STATE_HOME:-$HOME/.local/state}/nix/profile"
  ];
  _file = ./nix.nix;
}
