{ lib, config }:
{
  options.local.packages = lib.mkOption {
    type = lib.types.attrsOf lib.types.package;
    default = { };
  };
  config.environment.systemPackages = builtins.attrValues config.local.packages;
}
