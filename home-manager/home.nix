{config, pkgs, ...}:
{
  imports = [
    ./librewolf.nix
    ./sxhkd.nix
    ./rofi.nix
    ./polybar.nix
    ./theme.nix
    ./picom.nix
    ./git.nix
    ./spicetify.nix
    ./neovim
  ];
  xsession.numlock.enable = true;
  programs.home-manager.enable = true;
  home = {
    username = "gerg";
    homeDirectory = "/home/gerg";
    stateVersion = "22.11";
    file = {
      ".background-image".source = ../images/nix-stars.png;
      ".config" = {
        source = ./config;
        recursive = true;
      };
      ".dwm" = {
        source = ./dwm;
        recursive = true;
      };
    };
  };
}
