{ _file }:
{ config, lib, ... }:
{
  options.local.DM = {
    autoLogin = lib.mkEnableOption "";
    loginUser = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };

  config = lib.mkIf config.local.DM.autoLogin {
    services.displayManager = {
      autoLogin = {
        enable = true;
        user = config.local.DM.loginUser;
      };
    };
  };
  inherit _file;
}
