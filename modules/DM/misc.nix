{lib, ...}: {
  options.localModules.DM.loginUser = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
  };
}
