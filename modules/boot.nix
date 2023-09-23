{self, ...}: {
  lib,
  pkgs,
  config,
  ...
}: {
  options.local.bootConfig.disable = lib.mkEnableOption "";
  config = lib.mkIf (!config.local.bootConfig.disable) {
    environment.etc = {
      "issue" = {
        text = "[?12l[?25h";
        mode = "0444";
      };
    };
    boot = {
      blacklistedKernelModules = ["pcspkr"];
      kernelParams = lib.mkAfter [
        "acpi_call"
        "pti=auto"
        "randomize_kstack_offset=on"
        "vsyscall=none"
        "slab_nomerge"
        "module.sig_enforce=1"
        "lockdown=confidentiality"
        "page_poison=1"
        "page_alloc.shuffle=1"
        "sysrq_always_enabled=0"
        "idle=nomwait"
        "rootflags=noatime"
        "iommu=pt"
        "usbcore.autosuspend=-1"
        "noresume"
        "acpi_backlight=native"
        "logo.nologo"
        "fbcon=nodefer"
        "bgrt_disable"
        "systemd.show_status=false"
        "rd.udev.log_level=3"
        "vt.global_cursor_default=0"
        "quiet"
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
        logo = "${self.packages.${pkgs.system}.images}/logo.png";
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
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      path = [pkgs.efibootmgr];
      wantedBy = ["default.target"];
      script = ''
        efibootmgr -t 0
      '';
    };
  };
  _file = ./misc.nix;
}
