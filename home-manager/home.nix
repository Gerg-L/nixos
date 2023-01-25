{
  pkgs,
  settings,
  lib,
  ...
}: {
  imports = let
    modules = [
      "librewolf"
      "sxhkd"
      "theme"
      "picom"
      "spicetify"
    ];
  in
    lib.lists.forEach modules (
      m:
        ./. + ("/" + m + ".nix")
    )
    ++ [
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
