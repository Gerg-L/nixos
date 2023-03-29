_: {
  self,
  lib,
  ...
}: {
  boot = {
    plymouth = {
      enable = lib.mkDefault true;
      theme = "breeze";
      logo = "${self}/misc/nixos.png";
    };
    loader = {
      systemd-boot = {
        enable = lib.mkDefault true;
        consoleMode = "max";
        editor = false;
      };
      efi.canTouchEfiVariables = lib.mkDefault true;
      timeout = 0;
    };
  };
}
