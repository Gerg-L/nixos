inputs: {
  imports = [
    (import ./boot.nix inputs)
    (import ./misc.nix inputs)
    (import ./packages.nix inputs)
    (import ./X11.nix inputs)
    (import ./nix.nix inputs)
    (import ./unfree.nix inputs)
    (import ./DE inputs)
    (import ./DM inputs)
    (import ./hardware.nix inputs)
  ];
}
