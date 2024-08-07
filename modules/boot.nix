{
  self',
  lib,
  config,
  pkgs,
}:
{
  options.local.bootConfig.disable = lib.mkEnableOption "";
  config = lib.mkIf (!config.local.bootConfig.disable) {
    environment.etc = {
      "issue" = {
        text = "[?12l[?25h";
        mode = "0444";
      };
    };
    boot = {
      blacklistedKernelModules = [ "pcspkr" ];
      kernelParams = lib.mkBefore [
        "logo.nologo"
        "fbcon=nodefer"
        "bgrt_disable"
        "vt.global_cursor_default=0"
        "quiet"
        "systemd.show_status=false"
        "rd.udev.log_level=3"
        "splash"
      ];
      consoleLogLevel = 3;
      initrd = {
        verbose = false;
        systemd.enable = true;
      };
      plymouth = {
        enable = lib.mkDefault true;
        theme = "breeze";
        logo = "${self'.packages.images}/logo.png";
      };
      loader = {
        grub = {
          configurationLimit = 10;
          extraConfig = ''
            GRUB_TIMEOUT_STYLE=hidden
          '';
        };
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
    systemd.services.efibootmgr = {
      reloadIfChanged = false;
      restartIfChanged = false;
      stopIfChanged = false;
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = "${lib.getExe' pkgs.efibootmgr "efibootmgr"} -t 0";
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };
  };
}
