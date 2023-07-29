_: {
  pkgs,
  config,
  lib,
  ...
}: {
  options.local.git.disable = lib.mkOption {
    type = lib.types.bool;
    default = false;
  };

  config = lib.mkIf (! config.local.git.disable) {
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
        advice.addIgnoredFile = false;
        core.hooksPath = ".githooks";
      };
    };
  };
  _file = ./git.nix;
}
