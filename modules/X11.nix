_:
{ pkgs, lib, ... }:
{
  services.xserver = {
    tty = lib.mkDefault 1;
    exportConfiguration = true;
    layout = "us";
    libinput.enable = true;
    xautolock.enable = false;
    excludePackages = [ pkgs.xterm ];
    desktopManager.xterm.enable = false;
  };
  _file = ./X11.nix;
}
