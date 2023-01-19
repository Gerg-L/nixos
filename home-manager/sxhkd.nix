{
  services.sxhkd = {
    enable = true;
    keybindings = {
      #media keybindings
      "XF86AudioPlay" = "playerctl play-pause";
      "XF86AudioPause" = "playerctl play-pause";
      "XF86AudioStop" = "playerctl stop";
      "XF86AudioNext" = "playerctl next";
      "XF86AudioPrev" = "playerctl previous";
      "XF86AudioRaiseVolume" = "amixer sset Master 40+";
      "XF86AudioLowerVolume" = "amixer sset Master 40-";
      "XF86AudioMute" = "amixer sset Master toggle ";
      "XF86MonBrightnessUp" = "brightnessctl s 20+";
      "XF86MonBrightnessDown" = "brightnessctl s 20-";
      #screenshot stuff
      "Print" = "maim $HOME/Screenshots/$(date +%Y-%m-%d_%H-%m-%s).jpg";
      "Print + shift" = "maim | xclip -selection clipboard -t image/png";
      "super + Print" = "maim -s $HOME/Screenshots/$(date +%Y-%m-%d_%H-%m-%s).jpg";
      "super + Print + shift" = "maim -s | xclip -selection clipboard -t image/png";
    };
  };
}
