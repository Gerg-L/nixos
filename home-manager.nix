{config, pkgs, home-manager, ...}:
{
  imports = [
    ./home-manager/zsh.nix
    ./home-manager/firefox.nix
    ./home-manager/bspwm.nix
    ./home-manager/sxhkd.nix
    ./home-manager/rofi.nix
    ./home-manager/polybar.nix
    ./home-manager/dunst.nix
    ./home-manager/alacritty.nix
    ./home-manager/theme.nix
    ./home-manager/picom.nix
  ];
  programs.home-manager.enable = true;
  home = {
    username = "gerg";
    homeDirectory = "/home/gerg";
    stateVersion = "22.11";
    file = {
      ".background-image".source = ./images/stars.jpg;
      ".config" = {
        source = ./home/.config;
        recursive = true;
      };
    };
  };
}
