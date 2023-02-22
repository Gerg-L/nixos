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
in {
  options.localModules.DE.dwm = {
    enable = mkEnableOption "";
  };

  config = mkIf cfg.enable {
    services.gvfs.enable = true;
    environment.systemPackages = [suckless.packages.${pkgs.system}.dmenu];
    services.xserver = {
      enable = true;
      windowManager.dwm = {
        enable = true;
        package = suckless.packages.${pkgs.system}.dwm;
      };
      displayManager = {
        sessionCommands = ''
          ${pkgs.feh}/bin/feh --bg-scale ${self + /misc/recursion.png}
        '';
        defaultSession = "none+dwm";
      };
    };
  };
}
