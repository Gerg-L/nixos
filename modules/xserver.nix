{config, ... }:
{
  services.xserver = {
    enable = true;
    videoDrivers = 
      if (config.networking.hostName == "gerg-laptop")
        then ["modesetting"  "nvidia"] 
      else [ "nvidia" ];
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
           extraConfig = ''
[greeter]
user = gerg
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
background-image = "/etc/nixos/images/stars-1080.jpg"
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

