{
  config,
  lib,
  ...
}: {
  options.localModules.DM = {
    autoLogin = lib.mkEnableOption "";
    loginUser = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };

  config = lib.mkIf config.localModules.DM.autoLogin {
    services.xserver.displayManager = {
      autoLogin = {
        enable = true;
        user = config.localModules.DM.loginUser;
      };
    };
  };
}
