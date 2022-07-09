{
  enable = true;
  videoDrivers = ["nvidia" "modesetting"];
  layout = "us";
  libinput.enable = true;
  desktopManager = {
    xterm.enable = false;
  };
  windowManager.bspwm = {
    enable = true;
  };
  displayManager = {
    defaultSession = "none+bspwm";
    lightdm = {
      enable = true;
      greeters.mini = {
        enable = true;
         extraConfig = (builtins.readFile ./lightdm-mini.conf);
        };
      };
    };
}

