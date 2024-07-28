{
  nix,
  inputs,
  lib,
  config,
  pkgs,
}:
{
  #
  # Flake registry and $NIX_PATH pinning
  #
  nix.registry = lib.pipe inputs [
    (lib.filterAttrs (_: lib.isType "flake"))
    (lib.mapAttrs (_: flake: { inherit flake; }))
    (x: x // { nixpkgs.flake = inputs.unstable; })
  ];

  environment.etc = lib.mapAttrs' (name: value: {
    name = "nix/path/${name}";
    value.source = value.flake;
  }) config.nix.registry;
  nix.nixPath = [ "/etc/nix/path" ];
  #
  # Ignore global registry
  #
  nix.settings.flake-registry = "";
  #
  # Use nix directly from master
  #
  nix.package = nix.packages.default;
  #
  # Other nix settings
  #
  nix.settings = {
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
    ];
    auto-optimise-store = true;
    warn-dirty = false;
    #
    # Use for testing
    #
    #allow-import-from-derivation = false;
    trusted-users = [ "root" ];
    allowed-users = [ "@wheel" ];
    use-xdg-base-directories = true;
    auto-allocate-uids = true;
  };
}
