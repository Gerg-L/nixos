_: {
  config,
  lib,
  options,
  ...
}:
with lib; let
  cfg = config.localModules.DE.xfce;
in {
  options.localModules.DE.xfce = {
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
