{config, pkgs, lib, ...}:
{
  xsession.windowManager.bspwm = {
    enable = true;
    startupPrograms = [
      "polybar left"
      "polybar middle"
      "polybar right"
      "xfce4-power-manager"
      "xsetroot -cursor_name left_ptr"
      "xsetroot -solid \"#000000\""
      "flashfocus"
      "polkit-gnome"
    ];
    settings = {
      border_width = 0;
      window_gap = 10;
      border_radius = 7;
      normal_border_color = "\#c0caf5";
      active_border_color = "\#c0caf5";
      focused_border_color = "\#c0caf5";
      spilt_ratio = 0.52;
      borderless_monocle = true;
      gapless_monocle = true;
    };
    monitors = {
      HDMI-0 = [ "I" "II" "III" "IV" "V" ];
      eDP-1 =  [ "VI" "VII" "VIII" "IX" "X" ];
    };
  };
}
