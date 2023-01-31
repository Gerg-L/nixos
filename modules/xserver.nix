{
  pkgs,
  settings,
  ...
}: {
  services.xserver = {
    enable = true;
    exportConfiguration = true; #make config debuggable
    layout = "us";
    libinput.enable = true;
    xautolock.enable = false;
    desktopManager.xterm.enable = false;
    excludePackages = [pkgs.xterm];
    windowManager.dwm.enable = true;
    displayManager = {
      sessionCommands = ''
        feh --bg-scale ${../images/recursion.png}
      '';
      defaultSession = "none+dwm";
      lightdm = {
        enable = true;
        greeters.mini = {
          enable = true;
          extraConfig = ''
            [greeter]
            user = ${settings.username}
            show-password-label = false
            password-label-text =
            invalid-password-text =
            show-input-cursor = false
            password-alignment = center
            password-input-width = 19
            show-image-on-all-monitors = true


            [greeter-hotkeys]
            mod-key = meta
            shutdown-key = s
            restart-key = r
            hibernate-key = h
            suspend-key = u


            [greeter-theme]
            font = "OverpassMono Nerd Font"
            font-size = 1.1em
            font-weight = bold
            font-style = normal
            text-color = "#7AA2F7"
            error-color = "#DB4B4B"
            background-image = "${../images/recursion.png}"
            background-color = "#000000"
            window-color = "#000000"
            border-color = "#000000"
            border-width = 2px
            layout-space = 15
            password-character = -1
            password-color = "#7AA2F7"
            password-background-color = "#24283B"
            password-border-color = "#000000"
            password-border-width = 2px
            password-border-radius = 0.341125em
          '';
        };
      };
    };
  };
}
