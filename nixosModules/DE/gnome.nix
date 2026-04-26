{
  config,
  lib,
  pkgs,
}:
{
  options.local.DE.gnome.enable = lib.mkEnableOption "";

  config = lib.mkIf config.local.DE.gnome.enable {
    environment = {
      systemPackages = [
        pkgs.gnome-calculator
        pkgs.gnome-clocks
        pkgs.gnome-console
        pkgs.gnome-tweaks
        pkgs.gnomeExtensions.desktop-icons-ng-ding
      ];
    };

    services = {
      gnome = {
        games.enable = false;
        core-apps.enable = false;
      };
      displayManager.defaultSession = "gnome";
      desktopManager.gnome.enable = true;
    };
  };
}
