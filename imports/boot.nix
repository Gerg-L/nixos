{pkgs, ...}: {
  environment.etc = {
    "issue" = {
      text = "[?12l[?25h";
      mode = "0444";
    };
  };
  boot = {
    blacklistedKernelModules = ["nouveau" "lbm-nouveau" "pcspkr"];
    kernelParams = ["fbcon=nodefer" "bgrt_disable" "quiet" "systemd.show_status=false" "rd.udev.log_level=3" "vt.global_cursor_default=0"];
    consoleLogLevel = 0;
    initrd.verbose = false;
    plymouth = {
      enable = true;
      theme = "breeze";
      logo = ../images/nixos.png;
    };
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
        editor = false;
      };
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
  };
}
