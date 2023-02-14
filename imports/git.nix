_:{pkgs, ...}: {
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
}
