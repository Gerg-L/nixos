{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.localModules.git;
in {
  options.localModules.git = {
    disable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf (! cfg.disable) {
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
