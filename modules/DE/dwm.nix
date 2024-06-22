{
  pkgs,
  config,
  lib,
  suckless,
  self',
}:
{
  options.local.DE.dwm.enable = lib.mkEnableOption "";

  config = lib.mkIf config.local.DE.dwm.enable {
    systemd.user.services = {
      sxhkd = {
        path = [ pkgs.sxhkd ];
        script = "sxhkd -c /etc/sxhkd/sxhkdrc";
        serviceConfig = {
          Restart = "always";
          RestartSec = 2;
          ExecReload = "pkill -usr1 -x $MAINPID";
        };
      };

      picom = {
        path = [ pkgs.picom ];
        script = "picom";
        serviceConfig = {
          Restart = "always";
          RestartSec = 2;
          ExecReload = "pkill -usr1 -x $MAINPID";
        };
      };
    };

    services.gvfs.enable = true;

    services.displayManager.defaultSession = "none+dwm";

    services.xserver = {
      enable = true;
      displayManager = {
        sessionCommands = ''
          feh --bg-center "${self'.packages.images}/recursion.png"
          numlockx
          systemctl --user start sxhkd
          systemctl --user start picom
        '';
      };
      windowManager.session = [
        {
          name = "dwm";
          start = ''
            update_time () {
              while :
              do
                sleep 1
                xsetroot -name "$(date +"%I:%M %p")"
              done
            }

            dont_stop() {
              while type dwm >/dev/null ; do dwm && continue || break ; done
            }

            update_time &
            dont_stop &
            waitPID=$!
          '';
        }
      ];
    };
    environment = {
      systemPackages = builtins.attrValues {
        inherit (suckless.packages) dmenu dwm st;
        inherit (pkgs)
          maim
          playerctl
          xclip
          feh
          numlockx
          picom
          sxhkd
          alock
          ;
      };
      etc = {
        "xdg/Xresources".text = ''
          ALock*input.frame*input:  #74b2ff
          ALock*input.frame*check:  #36c692
          ALock*Input.frame*width:  2
        '';
        "sxhkd/sxhkdrc".text = ''
          XF86AudioPlay
            playerctl play-pause
          XF86AudioPause
            playerctl play-pause
          XF86AudioStop
            playerctl stop
          XF86AudioNext
            playerctl next
          XF86AudioPrev
            playerctl previous
          XF86AudioRaiseVolume
            wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+
          XF86AudioLowerVolume
            wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-
          XF86AudioMute
            wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
          Print
            maim $HOME/Screenshots/$(date +%Y-%m-%d_%H-%m-%s).jpg
          Print + shift
            maim | xclip -selection clipboard -t image/png
          super + Print
            maim -s $HOME/Screenshots/$(date +%Y-%m-%d_%H-%m-%s).jpg
          super + Print + shift
            maim -s | xclip -selection clipboard -t image/png
          super + ctrl + r
            pkill -usr1 -x sxhkd
          super + ctrl + l
            sleep 1 && xset dpms force off && alock
        '';
      };
    };
  };
}
