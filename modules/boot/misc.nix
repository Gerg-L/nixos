{
  self,
  lib,
  pkgs,
  ...
}: {
  environment.etc = {
    "issue" = {
      text = "[?12l[?25h";
      mode = "0444";
    };
  };
  boot = {
    blacklistedKernelModules = ["pcspkr"];
    kernelParams = ["fbcon=nodefer" "bgrt_disable" "quiet" "systemd.show_status=false" "rd.udev.log_level=3" "vt.global_cursor_default=0"];
    consoleLogLevel = 3;
    initrd.verbose = false;
    plymouth = {
      enable = lib.mkDefault true;
      theme = "breeze";
      logo = self.packages.${pkgs.system}.images + /logo.png;
    };
    loader = {
      grub.configurationLimit = 10;
      systemd-boot = {
        configurationLimit = 10;
        enable = lib.mkDefault true;
        consoleMode = "max";
        editor = false;
      };
      efi.canTouchEfiVariables = lib.mkDefault true;
      timeout = 0;
    };
  };
}
