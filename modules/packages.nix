{
  pkgs,
  lib,
  ...
}: {
  environment.defaultPackages = lib.mkForce [
    pkgs.efibootmgr #efi editor
    pkgs.pciutils #lspci
    pkgs.alsa-utils #volume control
    pkgs.xclip #commandline clipboard access
    pkgs.bottom #view tasks
    pkgs.nix-tree #view packages
    pkgs.nix-output-monitor #nom nom nom nom];
  ];
}
