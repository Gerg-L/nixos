{
  suckless,
  self,
  ...
}: {
  pkgs,
  config,
  lib,
  ...
}: {
  options.local.DE.dwm.enable = lib.mkEnableOption "";

  config = lib.mkIf config.local.DE.dwm.enable {
    services.gvfs.enable = true;
    services.xserver = {
      enable = true;
      displayManager = {
        sessionCommands = ''
          ${lib.getExe pkgs.feh} --bg-center "${self.packages.${pkgs.system}.images}/recursion.png"
          ${lib.getExe pkgs.numlockx}
          ${lib.getExe pkgs.picom} &
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
    environment.systemPackages = builtins.attrValues {
      inherit
        (suckless.packages.${pkgs.system})
        dmenu
        dwm
        st
        ;
    };
  };
}
