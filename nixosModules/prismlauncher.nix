{
  config,
  pkgs,
  lib,
}:
let
  cfg = config.local.prismlauncher;
  getMajor = x: lib.versions.major (lib.getVersion x);
in
{
  options = {
    local.prismlauncher = {
      enable = lib.mkEnableOption "prismlauncher";
      jdks = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [
          pkgs.openjdk8
          pkgs.openjdk17
          pkgs.openjdk21
        ];
      };
    };
  };
  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = lib.singleton (
        pkgs.prismlauncher.override {
          jdks = map (x: "/etc/jdks/${getMajor x}") cfg.jdks;
        }
      );
      etc = builtins.listToAttrs (
        map (x: {
          name = "jdks/${getMajor x}";
          value.source = lib.getBin x;
        }) cfg.jdks
      );
    };
  };
}
