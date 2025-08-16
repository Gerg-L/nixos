{ pkgs }:
{
  services.libinput.mouse.accelProfile = "flat";
  services.xserver = {
    exportConfiguration = true;
    xkb.layout = "us";
    xautolock.enable = false;
    excludePackages = [ pkgs.xterm ];
    desktopManager.xterm.enable = false;
  };
}
