let
  flake = builtins.getFlake (toString ./.);
  nixpkgs = import <nixpkgs> {};
in {
  inherit flake;
  inherit nixpkgs;
  nixos = flake.nixosConfigurations;
}
