{
  pkgs,
  settings,
  ...
}: {
  imports = [
    ./librewolf.nix
    ./sxhkd.nix
    ./theme.nix
    ./picom.nix
    ./spicetify.nix
    ./neovim
  ];
  xsession.numlock.enable = true;
  home = {
    homeDirectory = "/home/${settings.username}";
    stateVersion = settings.version;
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
