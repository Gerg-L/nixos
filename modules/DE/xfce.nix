{
  config,
  lib,
  pkgs,
  ...
}: {
  options.localModules.DE.xfce.enable = lib.mkEnableOption "";

  config = lib.mkIf config.localModules.DE.xfce.enable {
    environment.systemPackages = [pkgs.xfce.xfce4-whiskermenu-plugin];
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
