{config, pkgs, ...}:
{
  imports = [
    ./firefox.nix
    ./bspwm.nix
    ./sxhkd.nix
    ./rofi.nix
    ./polybar.nix
    ./dunst.nix
    ./alacritty.nix
    ./theme.nix
    ./picom.nix
    ./git.nix
    ./neovim.nix
    ./spicetify.nix
  ];
  xsession.numlock.enable = true;
  programs.home-manager.enable = true;
  home = {
    username = "gerg";
    homeDirectory = "/home/gerg";
    stateVersion = "22.11";
    file = {
      ".background-image".source = ../images/stars.jpg;
      ".config" = {
        source = ./config;
        recursive = true;
      };
    };
  };
}
