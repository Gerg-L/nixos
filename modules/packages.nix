{ config, pkgs, callPackage, ... }:
{
environment.systemPackages = with pkgs; [     
     wget
     htop #view tasks
     efibootmgr #efi editor
     maim #screenshooter
     curlFull
     #lightm stuff
     lightdm
     lightdm-mini-greeter
     #needed utils
     mesa #3d acceleration
     pciutils
     binutils
     alsa-utils
     btrfs-progs #for external harddrive
     #user/gui
     discord
     spotify-tray
     vlc
     bitwarden
     gimp
     qbittorrent
     feh #for wallpaper
     #explicit xfce4 for bspwm
     xarchive
     xfce.catfish
     xfce.mousepad
     xfce.xfce4-power-manager
     #shiny
     brightnessctl
     playerctl
     networkmanager_dmenu
     networkmanagerapplet
     dmenu
     flashfocus
     pavucontrol
     xclip
     neofetch
     #my polkit fix
     polkit_fix
     #for thunar root
     qsudo
  ];
}
