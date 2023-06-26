inputs: {pkgs, ...}: {
  #other nix settings
  nix = {
    package = inputs.nix.packages.${pkgs.system}.default;
    settings = {
      experimental-features = ["nix-command" "flakes" "repl-flake"];
      auto-optimise-store = true;
      warn-dirty = false;
      #ignore global registry
      flake-registry = builtins.toFile "empty-flake-registry.json" ''{"flakes":[],"version":2}'';
      #use for testing
      #allow-import-from-derivation = false;
      trusted-users = [
        "root"
        "@wheel"
      ];
      allowed-users = [
      ];
      use-xdg-base-directories = true;
    };
  };
  #fix for use-xdg-base-directories
  environment.profiles = [
    "$HOME/.local/state/nix/profiles/profile"
  ];
}
