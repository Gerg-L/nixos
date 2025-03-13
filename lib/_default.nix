{
  unstable,
  ...
}@inputs:
let
  inherit (unstable) lib;
in
lib.fix (self: (import ./overlay.nix inputs self lib))
