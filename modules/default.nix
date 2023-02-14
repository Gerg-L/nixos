inputs: {
  imports = [
    (import ./sxhkd.nix inputs)
    (import ./unfree.nix inputs)
  ];
}
