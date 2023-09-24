_:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.local.DE.xfce.enable = lib.mkEnableOption "";

  config = lib.mkIf config.local.DE.xfce.enable {
    environment.systemPackages = [ pkgs.xfce.xfce4-whiskermenu-plugin ];
    services.xserver = {
      enable = true;
      desktopManager.xfce = {
        enable = true;
        enableScreensaver = true;
      };
      displayManager.defaultSession = "xfce";
    };
  };
  _file = ./xfce.nix;
}
