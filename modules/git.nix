{
  pkgs,
  config,
  lib,
  ...
}: {
  options.localModules.git.disable = lib.mkOption {
    type = lib.types.bool;
    default = false;
  };

  config = lib.mkIf (! config.localModules.git.disable) {
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
