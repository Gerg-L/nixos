{ config, pkgs, callPackage, ... }:
{
environment.systemPackages = with pkgs; [     
     #single commands
     nano 
     wget
     neofetch
     htop
     efibootmgr
     maim
     curlFull
     #lightdm
     lightdm
     lightdm-mini-greeter
     #needed utils
     pipewire
     xorg.xf86videoamdgpu
     mesa
     mesa-demos
     pciutils
     git
     dash
     binutils
     #user/gui
     discord
     spotify
     spotify-tray
     vlc
     bitwarden
     protonvpn-gui
     gimp
     qbittorrent
     feh
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
     qsudo
     flashfocus
     pavucontrol
     gpick
     xclip
     alsa-utils
  ];
}
