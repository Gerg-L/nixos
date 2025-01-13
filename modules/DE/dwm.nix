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
    local.packages = {
      inherit (suckless.packages) dmenu dwm st;
      inherit (pkgs)
        maim
        playerctl
        xclip
        feh
        numlockx
        picom
        sxhkd
        xscreensaver
        ;

      xsecurelock = pkgs.writeShellScriptBin "xsecurelock" ''
        export XSECURELOCK_BLANK_TIMEOUT="30"
        export XSECURELOCK_AUTH_TIMEOUT="30"
        export XSECURELOCK_BLANK_DPMS_STATE="off"
        export XSECURELOCK_BACKGROUND_COLOR="#000000"
        export XSECURELOCK_AUTH_BACKGROUND_COLOR="#080808"
        export XSECURELOCK_AUTH_FOREGROUND_COLOR="#bdbdbd"
        export XSECURELOCK_FONT="Overpass"
        export XSECURELOCK_SHOW_DATETIME="1"
        ${lib.getExe pkgs.xsecurelock}
      '';
    };
    systemd.user.services = {
      sxhkd = {
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${lib.getExe pkgs.sxhkd} -c /etc/sxhkd/sxhkdrc";
          Restart = "always";
          RestartSec = 2;
          ExecReload = "pkill -usr1 -x $MAINPID";
        };
      };

      picom = {
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${lib.getExe pkgs.picom} --backend egl";
          Restart = "always";
          RestartSec = 2;
          ExecReload = "pkill -usr1 -x $MAINPID";
        };
      };
    };
    services = {
      gvfs.enable = true;
      displayManager.defaultSession = "none+dwm";
      xserver = {
        enable = true;
        displayManager = {
          sessionCommands = ''
            feh --bg-center "${self'.packages.images}/recursion.png"
            numlockx
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
    };

    environment.etc."sxhkd/sxhkdrc".text = ''
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
        xsecurelock
    '';
  };
}
