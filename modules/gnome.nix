{
  pkgs,
  settings,
  ...
}: {
  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-photos
      gnome-tour
    ])
    ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-music
      gnome-terminal
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
  dconf.settings = {
    "org/gnome/desktop/background" = {
      "picture-uri" = "${../images/recursion.png}";
    };
    "org/gnome/desktop/screensaver" = {
      "picture-uri" = "${../images/recursion.png}";
    };
  };
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
    };
  };
}
