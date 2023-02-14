_: {pkgs, ...}: {
  environment = {
    defaultPackages = []; #don't install anything by default
    systemPackages = [
      pkgs.efibootmgr #efi editor
      pkgs.pciutils #lspci
      pkgs.alsa-utils #volume control
      pkgs.xclip #commandline clipboard access
      pkgs.btrfs-progs #for external harddrive
      pkgs.feh #for wallpaper #directly used tui apps
      pkgs.bottom #view tasks
      pkgs.bc #terminal calculator
      pkgs.nix-tree #view packages
      #pointless stuff
      pkgs.cava #pretty audio
      pkgs.pipes-rs # more fun things
      #gui apps
      pkgs.pavucontrol #gui volume control
      pkgs.pcmanfm #file manager
      #big gui apps
      pkgs.librewolf #best browser
    ];
  };
}
