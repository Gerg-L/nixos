inputs: {
  imports = [
    (import ./stage2patch.nix inputs)
    (import ./silent.nix inputs)
    (import ./misc.nix inputs)
  ];
}
