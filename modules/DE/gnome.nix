_: {
  config,
  lib,
  options,
  pkgs,
  ...
}: let
  cfg = config.localModules.DE.gnome;
in {
  options.localModules.DE.gnome = {
    enable = lib.mkEnableOption "";
  };
  config = lib.mkIf cfg.enable {
    environment.gnome.excludePackages = [
      pkgs.gnome-photos
      pkgs.gnome-tour
      pkgs.gnome-text-editor
      pkgs.gnome-online-accounts

      pkgs.gnome.gnome-weather
      pkgs.gnome.gnome-shell
      pkgs.gnome.gnome-disk-utility
      pkgs.gnome.gnome-maps
      pkgs.gnome.gnome-clocks
      pkgs.gnome.gnome-remote-desktop
      pkgs.gnome.gnome-calendar
      pkgs.gnome.gnome-music
      pkgs.gnome.simple-scan
      pkgs.gnome.cheese # webcam tool
      pkgs.gnome.gedit # text editor
      pkgs.gnome.epiphany # web browser
      pkgs.gnome.geary # email reader
      pkgs.gnome.evince # document viewer
      pkgs.gnome.gnome-characters
      pkgs.gnome.totem # video player
      pkgs.gnome.tali # poker game
      pkgs.gnome.iagno # go game
      pkgs.gnome.hitori # sudoku game
      pkgs.gnome.atomix # puzzle game
    ];
    services.xserver = {
      enable = true;
      desktopManager.gnome.enable = true;
      displayManager.defaultSession = "gnome";
    };
  };
}
