_: {
  config,
  lib,
  options,
  pkgs,
  ...
}:
with lib; let
  cfg = config.localModules.DE.gnome;
in {
  options.localModules.DE.gnome = {
    enable = mkEnableOption "";
  };
  config = mkIf cfg.enable {
    environment.gnome.excludePackages =
      (with pkgs; [
        gnome-photos
        gnome-tour
        gnome-text-editor
        gnome-online-accounts
      ])
      ++ (with pkgs.gnome; [
        gnome-weather
        gnome-shell
        gnome-calculator
        gnome-disk-utility
        gnome-maps
        gnome-clocks
        gnome-remote-desktop
        gnome-calendar
        gnome-music
        simple-scan
        cheese # webcam tool
        gedit # text editor
        epiphany # web browser
        geary # email reader
        evince # document viewer
        gnome-characters
        totem # video player
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
      ]);
    services.xserver = {
      enable = true;
      desktopManager.gnome.enable = true;
      displayManager.defaultSession = "gnome";
    };
  };
}
