{ config, pkgs, callPackage, webcord, ... }:
{
environment.systemPackages = with pkgs; [     
     wget #wget
     bottom #view tasks
     efibootmgr #efi editor
     maim #screenshooter
     #needed utils
     pciutils
     binutils
     alsa-utils
     btrfs-progs #for external harddrive
     #user/gui
     vlc
     bitwarden
     gimp
     qbittorrent
     webcord.packages.${pkgs.system}.default
     spotify-tray
     feh #for wallpaper
     #explicit xfce4 for bspwm
     xarchive
     xfce.catfish
     xfce.mousepad
     xfce.xfce4-power-manager
     brightnessctl #brightness control for laptop
     playerctl #music control
     networkmanager_dmenu #pretty gui connection control
     networkmanagerapplet #gui connection control
     dmenu #for networkmanager_dmenu
     flashfocus #flash when switching windows
     pavucontrol #gui volume control
     xclip #commandline clipboard access
     qsudo #for running thunar as root
     nix-tree #show nixpkgs
     git-filter-repo
     exa #ls replacement
     cava #pretty audio
     neofetch
     piper # mouse configuration
     libratbag

     st
  ];
}

