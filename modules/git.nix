_: {
  pkgs,
  options,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.localModules.git;
in {
  options.localModules.git = {
    disable = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = mkIf (! cfg.disable) {
    programs.git = {
      enable = true;
      package = pkgs.gitMinimal;
      config = {
        user = {
          name = "Gerg-L";
          email = "GregLeyda@proton.me";
        };
        init = {
          defaultBranch = "master";
        };
        push = {
          autoSetupRemote = true;
        };
      };
    };
  };
}
