_: {
  options,
  lib,
  ...
}:
with lib; {
  options.localModules.DM.loginUser = mkOption {
    type = types.nullOr types.str;
    default = null;
  };
}
