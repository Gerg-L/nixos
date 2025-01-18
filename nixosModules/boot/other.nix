{
  lib,
  self',
  pkgs,
  config,
}:
{
  options.local.bootConfig.disable = lib.mkEnableOption "";

  config = lib.mkIf (!config.local.bootConfig.disable) {
    boot = {
      loader = {
        grub.configurationLimit = 10;
        systemd-boot = {
          configurationLimit = 10;
          enable = lib.mkDefault true;
          consoleMode = "max";
          editor = false;
        };

        efi.canTouchEfiVariables = lib.mkDefault true;
      };
      plymouth = {
        enable = lib.mkDefault true;
        theme = "breeze";
        logo = "${self'.packages.images}/logo.png";
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
