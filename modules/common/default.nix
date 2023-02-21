inputs: {
  imports = [
    (import ./nix.nix inputs)
    (import ./x.nix inputs)
  ];
}
