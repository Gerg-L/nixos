{ config, pkgs, callPackage, ... }:
{
  environment.systemPackages = with pkgs; [
    bottom #view tasks
    efibootmgr #efi editor
    maim #screenshooter
    pciutils #lspci
    alsa-utils #volume control
    btrfs-progs #for external harddrive
    vlc #play stuff
    bitwarden #store stuff
    gimp #edit stuff 
    qbittorrent #steal stuff 
    discord # talk to people (gross)
    feh #for wallpaper
    xfce.mousepad
    brightnessctl #brightness control for laptop
    playerctl #music control
    networkmanager_dmenu #pretty gui connection control
    networkmanagerapplet #gui connection control
    dmenu #for networkmanager_dmenu
    pavucontrol #gui volume control
    xclip #commandline clipboard access
    exa #ls replacement
    cava #pretty audio
    neofetch # cus yes
    st #suckless terminal
    pipes-rs # more fun things
    pcmanfm #file manager 
    haskellPackages.squeeze #file compression
    nix-tree #view packages
  ];
}

