_: {
  config,
  lib,
  options,
  settings,
  ...
}:
with lib; let
  cfg = config.localModules.autoLogin;
in {
  options.localModules.autoLogin = {
    enable = mkEnableOption "";
  };
  config = mkIf cfg.enable {
    services.xserver.displayManager = {
      autoLogin = {
        enable = true;
        user = settings.username;
      };
    };
  };
}
