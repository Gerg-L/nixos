inputs: {
  imports = [
    (import ./minecraft.nix inputs)
    (import ./website.nix inputs)
  ];
}
