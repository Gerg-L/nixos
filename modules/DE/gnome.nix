_:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.local.DE.gnome.enable = lib.mkEnableOption "";

  config = lib.mkIf config.local.DE.gnome.enable {
    environment = {
      systemPackages = [ pkgs.gnome.gnome-calculator ];
      gnome.excludePackages = builtins.attrValues {
        inherit (pkgs)
          gnome-photos
          gnome-tour
          gnome-text-editor
          gnome-online-accounts
          ;
        inherit (pkgs.gnome)
          gnome-weather
          gnome-shell
          gnome-disk-utility
          gnome-maps
          gnome-clocks
          gnome-remote-desktop
          gnome-calendar
          gnome-music
          simple-scan
          cheese # webcam tool
          epiphany # web browser
          geary # email reader
          evince # document viewer
          gnome-characters
          totem # video player
          tali # poker game
          iagno # go game
          hitori # sudoku game
          atomix # puzzle game
          ;
      };
    };

    services.xserver = {
      enable = true;
      desktopManager.gnome.enable = true;
      displayManager.defaultSession = "gnome";
    };
  };
  #_file
}
