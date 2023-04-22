_: {
  config,
  lib,
  options,
  ...
}: let
  cfg = config.localModules.DE.xfce;
in {
  options.localModules.DE.xfce = {
    enable = lib.mkEnableOption "";
  };
  config = lib.mkIf cfg.enable {
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
