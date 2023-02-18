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
      defaultSession = "gnome";
      lightdm = {
        enable = true;
        extraConfig = "minimum-vt=1";
        background = ../images/recursion.png;
        greeters.mini = {
          enable = true;
          user = settings.username;
          extraConfig = ''
            [greeter]
            show-password-label = false
            password-label-text =
            invalid-password-text =
            show-input-cursor = false
            password-alignment = center
            password-input-width = 19
            show-image-on-all-monitors = true


            [greeter-theme]
            font = "OverpassMono Nerd Font"
            font-size = 1.1em
            text-color = "#7AA2F7"
            error-color = "#DB4B4B"
            background-color = "#000000"
            window-color = "#000000"
            border-color = "#000000"
            password-character = -1
            password-color = "#7AA2F7"
            password-background-color = "#24283B"
            password-border-color = "#000000"
            password-border-radius = 0.341125em
          '';
        };
      };
    };
  };
}
