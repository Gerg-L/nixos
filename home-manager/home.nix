{
  config,
  pkgs,
  username,
  ...
}: {
  imports = [
    ./librewolf.nix
    ./sxhkd.nix
    ./theme.nix
    ./picom.nix
    ./git.nix
    ./spicetify.nix
    ./neovim
  ];
  xsession.numlock.enable = true;
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "23.05";
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
