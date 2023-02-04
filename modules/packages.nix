{pkgs, ...}: {
  environment = {
    defaultPackages = []; #don't install anything by default
    systemPackages = with pkgs; [
      efibootmgr #efi editor
      pciutils #lspci
      alsa-utils #volume control
      xclip #commandline clipboard access
      btrfs-progs #for external harddrive
      feh #for wallpaper

      #directly used tui apps
      bottom #view tasks
      bc #terminal calculator
      nix-tree #view packages
      #pointless stuff
      cava #pretty audio
      pipes-rs # more fun things

      #gui apps
      pavucontrol #gui volume control
      pcmanfm #file manager
      #big gui apps
      webcord # talk to people (gross)
      librewolf #best browser
    ];
  };
}
