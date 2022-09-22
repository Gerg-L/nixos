{config, pkgs, ...}:
{
  imports = [
    ./theme.nix
    ./git.nix
    ./neovim
    ./alacritty.nix
  ];
  programs.home-manager.enable = true;
  home = {
    username = "root";
    homeDirectory = "/root";
    stateVersion = "22.11";
    file = {
      ".config/Thunar" = {
        source = ./config/Thunar;
        recursive = true;
      };
      ".config/neofetch/config.conf" = {
        source = ./config/neofetch/config.conf;
        recursive = false;
      };
    };
  };
}
