inputs: {
  imports = [
    (import ./dwm.nix inputs)
    (import ./gnome.nix inputs)
    (import ./xfce.nix inputs)
  ];
}
