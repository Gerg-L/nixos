{
  config,
  lib,
  ...
}: let
  cfg = config.localModules.DM.autoLogin;
in {
  options.localModules.DM.autoLogin = lib.mkEnableOption "";
  config = lib.mkIf cfg {
    services.xserver.displayManager = {
      autoLogin = {
        enable = true;
        user = config.localModules.DM.loginUser;
      };
    };
  };
}
