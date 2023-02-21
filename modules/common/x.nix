_: {
  lib,
  pkgs,
  ...
}:
with lib; {
  services.xserver = {
    exportConfiguration = mkDefault true;
    layout = mkDefault "us";
    libinput.enable = mkDefault true;
    xautolock.enable = mkDefault false;
    desktopManager.xterm.enable = mkDefault false;
    excludePackages = mkDefault [pkgs.xterm];
  };
}
