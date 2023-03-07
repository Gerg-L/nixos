inputs: {
  imports = [
    (import ./DE inputs)
    (import ./DM inputs)

    (import ./boot.nix inputs)
    (import ./git.nix inputs)
    (import ./hardware.nix inputs)
    (import ./misc.nix inputs)
    (import ./nix.nix inputs)
    (import ./packages.nix inputs)
    (import ./shell.nix inputs)
    (import ./sops.nix inputs)
    (import ./theming.nix inputs)
    (import ./unfree.nix inputs)
    (import ./X11.nix inputs)
  ];
}
