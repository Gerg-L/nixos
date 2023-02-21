_: {
  lib,
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    "${toString modulesPath}/profiles/minimal.nix"
    "${toString modulesPath}/installer/cd-dvd/installation-cd-base.nix"
  ];

  environment = {
    noXlibs = lib.mkOverride 500 false;
    defaultPackages = [];
    systemPackages = with pkgs; [gitMinimal neovim];
    variables = {
      EDITOR = "nvim";
    };
  };
  documentation = {
    man.enable = lib.mkOverride 500 false;
    doc.enable = lib.mkOverride 500 false;
  };

  fonts.fontconfig.enable = lib.mkForce false;

  isoImage = {
    edition = lib.mkForce "gerg-minimal";

    isoName = lib.mkForce "NixOS.iso";
  };
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes" "repl-flake"];
      auto-optimise-store = true;
    };
  };
}
