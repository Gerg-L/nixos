{ config, pkgs, ... }:
{
  imports = [
    ./theme.nix
    ./git.nix
    ./neovim
  ];
  programs.home-manager.enable = true;
  home = {
    username = "root";
    homeDirectory = "/root";
    stateVersion = "23.05";
    file = {
      ".config/neofetch/config.conf" = {
        source = ./config/neofetch/config.conf;
        recursive = false;
      };
    };
  };
}
