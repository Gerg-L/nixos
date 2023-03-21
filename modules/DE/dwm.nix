{suckless, ...}: {
  pkgs,
  config,
  options,
  lib,
  self,
  ...
}:
with lib; let
  cfg = config.localModules.DE.dwm;
  sp = suckless.packages.${pkgs.system};
in {
  options.localModules.DE.dwm = {
    enable = mkEnableOption "";
  };

  config = mkIf cfg.enable {
    services.gvfs.enable = true;
    services.xserver = {
      enable = true;
      displayManager = {
        sessionCommands = ''
          ${pkgs.feh}/bin/feh --bg-center ${self + /misc/recursion.png}
          ${pkgs.numlockx}/bin/numlockx
          ${pkgs.picom}/bin/picom &
        '';
        defaultSession = "none+dwm";
      };
      windowManager.session =
        singleton
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
        };
    };
    environment.systemPackages = [
      sp.dmenu
      sp.dwm
    ];
  };
}
