inputs: {
  imports = [
    (import ./sxhkd.nix inputs)
    (import ./common inputs)
    (import ./unfree.nix inputs)
    (import ./DE-WM inputs)
    (import ./DM inputs)
    (import ./hardware.nix inputs)
  ];
}
