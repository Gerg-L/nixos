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
        '';
        defaultSession = "none+dwm";
      };
      windowManager.session =
        singleton
        {
          name = "dwm";
          start = ''
            dwm &
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
