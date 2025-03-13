{ pkgs, lib }:
{
  services.libinput.mouse.accelProfile = "flat";
  services.xserver = {
    tty = lib.mkDefault 1;
    exportConfiguration = true;
    xkb.layout = "us";
    xautolock.enable = false;
    excludePackages = [ pkgs.xterm ];
    desktopManager.xterm.enable = false;
  };
}
