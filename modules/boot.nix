{
  hardware.enableRedistributableFirmware = true;
  boot = {
    blacklistedKernelModules = ["nouveau" "lbm-nouveau" "pcspkr"];
    kernelParams = ["fbcon=nodefer" "bgrt_disable" "quiet" "splash"];
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
