_: {pkgs, ...}: {
  environment = {
    defaultPackages = []; #don't install anything by default
    systemPackages = [
      pkgs.efibootmgr #efi editor
      pkgs.pciutils #lspci
      pkgs.alsa-utils #volume control
      pkgs.xclip #commandline clipboard access
      pkgs.btrfs-progs #for external harddrive
      pkgs.bottom #view tasks
      pkgs.bc #terminal calculator
      pkgs.nix-tree #view packages
    ];
  };
}