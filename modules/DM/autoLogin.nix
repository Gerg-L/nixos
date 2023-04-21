_: {
  config,
  lib,
  options,
  ...
}:
with lib; let
  cfg = config.localModules.DM.autoLogin;
in {
  options.localModules.DM.autoLogin = mkEnableOption "";
  config = mkIf cfg {
    services.xserver.displayManager = {
      autoLogin = {
        enable = true;
        user = config.localModules.DM.loginUser;
      };
    };
  };
}
