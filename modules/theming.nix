_:
{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.local.theming;
in
{
  options.local.theming = {
    enable = lib.mkEnableOption "";
    kmscon.enable = lib.mkEnableOption "";
  };
  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
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
            gtk-font-name=Overpass 10
            gtk-icon-theme-name=Flat-Remix-Blue-Dark
            gtk-theme-name=Flat-Remix-GTK-Blue-Darkest
          '';
          "xdg/gtk-3.0/settings.ini".text = ''
            [Settings]
            gtk-cursor-theme-name=Quintom_Ink
            gtk-cursor-theme-size=16
            gtk-font-name=Overpass 10
            gtk-icon-theme-name=Flat-Remix-Blue-Dark
            gtk-theme-name=Flat-Remix-GTK-Blue-Darkest
          '';
          "xdg/gtk-2.0/gtkrc".text = ''
            gtk-cursor-theme-name = "Quintom_Ink"
            gtk-cursor-theme-size = 16
            gtk-font-name = "Overpass 10"
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
        ${lib.getExe' pkgs.xorg.xrdb "xrdb"} -load /etc/xdg/Xresources
      '';
      fonts = {
        packages = [
          pkgs.overpass
          (pkgs.nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
        ];
        enableDefaultPackages = false;
        fontDir.enable = true;
        fontconfig = {
          enable = true;
          defaultFonts = {
            serif = [ "Overpass" ];
            sansSerif = [ "Overpass" ];
            monospace = [ "Overpass Mono" ];
          };
          hinting.enable = true;
          antialias = true;
        };
      };
    })
    (lib.mkIf cfg.kmscon.enable {
      services.kmscon = {
        enable = true;
        hwRender = false;
        extraConfig = ''
          font-size=10
        '';
        fonts = [
          {
            name = "OverpassMono";
            package = pkgs.overpass;
          }
        ];
      };
      systemd.services = {
        "autovt@tty1".enable = false;
        "kmsconvt@tty1".enable = false;
      };
    })
  ];
  _file = ./theming.nix;
}
