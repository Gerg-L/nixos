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
      "bspc monitor -a I"
      "bspc monitor -a II"
      "bspc monitor -a III"
      "bspc monitor -a IV"
      "bspc monitor -a X"
    ];
    settings = {
      border_width = 0;
      window_gap = 20;
      border_radius = 15;
      normal_border_color = "\#c0caf5";
      active_border_color = "\#c0caf5";
      focused_border_color = "\#c0caf5";
      spilt_ratio = 0.52;
      borderless_monocle = true;
      gapless_monocle = true;
    };
  };
}
