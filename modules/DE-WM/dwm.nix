{suckless, ...}: {
  pkgs,
  config,
  options,
  lib,
  self,
  ...
}:
with lib; let
  cfg = config.localModules.dwm;
in {
  options.localModules.dwm = {
    enable = mkEnableOption "";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [suckless.packages.${pkgs.system}.dmenu];
    services.xserver = {
      enable = true;
      windowManager.dwm = {
        enable = true;
        package = suckless.packages.${pkgs.system}.dwm;
      };
      displayManager = {
        sessionCommands = ''
          feh --bg-scale ${self + /misc/recursion.png}
        '';
        defaultSession = "none+dwm";
      };
    };
  };
}
