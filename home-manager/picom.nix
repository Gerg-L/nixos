{
  services.picom = {
    enable = true;
    activeOpacity = "1.0";
    backend = "glx";
    blur = false;
    blurExclude = [
      "window_type = 'dock'"
      "window_type = 'menu'"
      "class_g = 'firefox'"
    ];
    experimentalBackends = false;
    fade = true;
    fadeDelta = 4;
    fadeSteps = [ "0.03" "0.03" ];
    inactiveOpacity = "1.0";
    menuOpacity = "1.0";
    shadow = true;
    noDockShadow = true;
    shadowExclude = [ "window_type = 'menu'" "class_g = 'firefox'" ];
    shadowOffsets = [ 25 25 ];
    shadowOpacity = "0.5";
    vSync = false;
    extraOptions = ''
animations: true;
animation-stiffness = 200
animation-window-mass = 0.4
animation-dampening = 20
animation-clamping = false
animation-for-open-window = "zoom";
animation-for-unmap-window = "zoom";
animation-for-workspace-switch-in = "slide-down";
animation-for-workspace-switch-out = "zoom";
animation-for-transient-window = "slide-up";

shadow-radius = 25;
frame-opacity = 1.0;
inactive-opacity-override = false;
corner-radius = 15;
rounded-corners-exclude = [
  "window_type = 'desktop'",
  "window_type = 'tooltip'",
];
mark-wmwin-focused = true;
mark-ovredir-focused = true;
detect-rounded-corners = true;
detect-client-opacity = true;
detect-transient = true;
use-damage = true;
log-level = "warn";
wintypes:
{
  tooltip = { fade = true; shadow = false; opacity = 1.0; focus = true; full-shadow = false; };
  dock = { shadow = true; }
  dnd = { shadow = true; }
  popup_menu = { opacity = 1.0; }
  dropdown_menu = { opacity = 1.0; }
};
    '';
  };
}
