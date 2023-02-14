_: {
  pkgs,
  settings,
  ...
}: {
  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-photos
      gnome-tour
      gnome-console
      gnome-text-editor
      gnome-online-accounts
    ])
    ++ (with pkgs.gnome; [
      gnome-terminal
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
    exportConfiguration = true; #make config debuggable
    layout = "us";
    libinput.enable = true;
    xautolock.enable = false;
    desktopManager.xterm.enable = false;
    excludePackages = [pkgs.xterm];
    desktopManager.gnome.enable = true;
    displayManager = {
      autoLogin = {
        enable = true;
        user = settings.username;
      };
      gdm.enable = true;
      defaultSession = "gnome";
    };
  };
}
