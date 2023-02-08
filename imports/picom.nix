{
  services.picom = {
    enable = true;
    backend = "glx";
    shadow = false;
    shadowOpacity = 0.5;
    vSync = false;
    settings = {
      blur = false;

      shadow-radius = 12;
      frame-opacity = 1.0;
      inactive-opacity-override = false;
      corner-radius = 12;
      rounded-corners-exclude = [
        "window_type = 'desktop'"
        "window_type = 'tooltip'"
      ];
      mark-wmwin-focused = true;
      mark-ovredir-focused = true;
      detect-rounded-corners = true;
      detect-client-opacity = true;
      detect-transient = true;
      use-damage = true;
      log-level = "warn";
      wintypes = {
        tooltip = {
          fade = true;
          shadow = false;
          opacity = 1.0;
          focus = true;
          full-shadow = false;
        };
        dock = {shadow = true;};
        dnd = {shadow = true;};
        popup_menu = {opacity = 1.0;};
        dropdown_menu = {opacity = 1.0;};
      };
    };
  };
}
