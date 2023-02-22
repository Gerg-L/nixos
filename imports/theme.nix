_: {pkgs, ...}: {
  environment = {
    systemPackages = [
      pkgs.flat-remix-gtk
      pkgs.flat-remix-icon-theme
      pkgs.quintom-cursor-theme
    ];
    etc = {
      "xdg/gtk-4.0/settings.ini".text = ''
        [Settings]
        gtk-cursor-theme-name=Quintom_Ink
        gtk-cursor-theme-size=16
        gtk-font-name = "Overpass Nerd Font 10"
        gtk-icon-theme-name=Flat-Remix-Blue-Dark
        gtk-theme-name=Flat-Remix-GTK-Blue-Darkest
      '';
      "xdg/gtk-3.0/settings.ini".text = ''
        [Settings]
        gtk-cursor-theme-name=Quintom_Ink
        gtk-cursor-theme-size=16
        gtk-font-name = "Overpass Nerd Font 10"
        gtk-icon-theme-name=Flat-Remix-Blue-Dark
        gtk-theme-name=Flat-Remix-GTK-Blue-Darkest
      '';
      "xdg/gtk-2.0/gtkrc".text = ''
        gtk-cursor-theme-name = "Quintom_Ink"
        gtk-cursor-theme-size = 16
        gtk-font-name = "Overpass Nerd Font 10"
        gtk-icon-theme-name = "Flat-Remix-Blue-Dark"
        gtk-theme-name = "Flat-Remix-GTK-Blue-Darkest"
      '';
      "xdg/Xresources".text = ''
        Xcursor.size: 16
        Xcursor.theme: Quintom_Ink
      '';
    };
  };
  qt = {
    enable = true;
    style = "gtk2";
    platformTheme = "gtk2";
  };
  services.xserver.displayManager.sessionCommands = ''
    xrdb -load /etc/xdg/Xresources
  '';
}
