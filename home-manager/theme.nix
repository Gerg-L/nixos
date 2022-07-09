{ pkgs, home-manager, ... }:
{
  gtk = {
    enable = true;
    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Blue-Darkest";
    };
    iconTheme = {
      package = pkgs.flat-remix-icon-theme;
      name = "Flat-Remix-Blue-Dark";
    };
    font = {
      name = "Overpass";
      size = 10;
    };
  };
}
