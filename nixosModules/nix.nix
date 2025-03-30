{
  nix,
  inputs,
  lib,
  config,
}:
{
  nix = {
    #
    # Disable usage of channels
    #
    channel.enable = false;
    #
    # Flake registry and $NIX_PATH pinning
    #
    registry = lib.pipe inputs [
      (lib.filterAttrs (_: lib.isType "flake"))
      (lib.mapAttrs (_: flake: { inherit flake; }))
      (x: x // { nixpkgs.flake = inputs.unstable; })
    ];
    nixPath = [ "/etc/nix/path" ];
    #
    # Ignore global registry
    #
    settings.flake-registry = "";
    #
    # Use nix directly from master
    #
    package = nix.packages.default;
    #
    # Other nix settings
    #
    settings = {
      substituters = lib.mkForce [
        "https://cache.nixos.org?priority=2"
        "https://nix-community.cachix.org?priority=3"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      experimental-features = [
        "auto-allocate-uids"
        "ca-derivations"
        "cgroups"
        "daemon-trust-override"
        "dynamic-derivations"
        "fetch-closure"
        "flakes"
        "nix-command"
        "no-url-literals"
        "parse-toml-timestamps"
        "read-only-local-store"
        "recursive-nix"
        "configurable-impure-env"
        "pipe-operators"
      ];
      auto-optimise-store = true;
      warn-dirty = false;
      #
      # Use for testing
      #
      #allow-import-from-derivation = false;
      trusted-users = [ "root" ];
      use-xdg-base-directories = true;
      auto-allocate-uids = true;
    };
  };

  environment.etc = lib.mapAttrs' (name: value: {
    name = "nix/path/${name}";
    value.source = value.flake;
  }) config.nix.registry;
}
