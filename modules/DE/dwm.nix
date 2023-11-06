{ suckless, self, ... }:
{
  pkgs,
  config,
  lib,
  ...
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

    services.xserver = {
      enable = true;
      displayManager = {
        sessionCommands = ''
          feh --bg-center "${self.packages.images}/recursion.png"
          numlockx
          systemctl --user start sxhkd
          systemctl --user start picom
        '';
        defaultSession = "none+dwm";
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
        ;
      };
      etc."sxhkd/sxhkdrc".text = ''
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
          amixer sset Master 1%+
        XF86AudioLowerVolume
          amixer sset Master 1%-
        XF86AudioMute
          amixer sset Master toggle
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
      '';
    };
  };
  _file = ./dwm.nix;
}
