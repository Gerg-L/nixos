_: {
  pkgs,
  config,
  ...
}: {
  programs.git = {
    enable = true;
    package = pkgs.gitMinimal;
    config = {
      user = {
        name = "Gerg-L";
        email = "GregLeyda@proton.me";
        signingkey = "~/.ssh/id_ed25519.pub";
      };
      init = {
        defaultBranch = "master";
      };
      push = {
        autoSetupRemote = true;
      };
      advice.addIgnoredFile = false;
      core.hooksPath = ".githooks";
      gpg.format = "ssh";
    };
  };
  _file = ./git.nix;
}
