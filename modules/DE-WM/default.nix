inputs: {
  imports = [
    (import ./gnome.nix inputs)
    (import ./xfce.nix inputs)
    (import ./dwm.nix inputs)
  ];
}
