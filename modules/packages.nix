{
  config,
  pkgs,
  inputs,
  ...
}: {
  environment = {
    defaultPackages = []; #don't install anything by default
    systemPackages = with pkgs; [
      bottom #view tasks
      efibootmgr #efi editor
      maim #screenshooter
      pciutils #lspci
      alsa-utils #volume control
      btrfs-progs #for external harddrive
      vlc #play stuff
      webcord # talk to people (gross)
      feh #for wallpaper
      xfce.mousepad
      brightnessctl #brightness control for laptop
      playerctl #music control
      networkmanagerapplet #gui connection control
      pavucontrol #gui volume control
      xclip #commandline clipboard access
      exa #ls replacement
      cava #pretty audio
      nitch # cus yes
      dmenu #suckless launcher
      st #suckless terminal
      pipes-rs # more fun things
      pcmanfm #file manager
      nix-tree #view packages
      bc #terminal calculator
      page #use nvim as a pager
      librewolf #best browser
      inputs.nvim-config.packages.${pkgs.system}.default #my custom nvim flake
    ];
  };
}
