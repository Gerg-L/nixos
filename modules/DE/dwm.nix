{
  inputs,
  pkgs,
  config,
  lib,
  self,
  ...
}: let
  cfg = config.localModules.DE.dwm;
  sp = inputs.suckless.packages.${pkgs.system};
in {
  options.localModules.DE.dwm = {
    enable = lib.mkEnableOption "";
  };

  config = lib.mkIf cfg.enable {
    services.gvfs.enable = true;
    services.xserver = {
      enable = true;
      displayManager = {
        sessionCommands = ''
          ${pkgs.feh}/bin/feh --bg-center ${self.packages.${pkgs.system}.images + /recursion.png}
          ${pkgs.numlockx}/bin/numlockx
          ${pkgs.picom}/bin/picom &
        '';
        defaultSession = "none+dwm";
      };
      windowManager.session =
        lib.singleton
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
      sp.st
    ];
  };
}
