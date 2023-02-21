_: {
  config,
  lib,
  options,
  ...
}:
with lib; let
  cfg = config.localModules.xfce;
in {
  options.localModules.xfce = {
    enable = mkEnableOption "";
  };
  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      desktopManager.xfce = {
        enable = true;
        enableScreensaver = true;
      };
      displayManager.defaultSession = "xfce";
    };
  };
}
