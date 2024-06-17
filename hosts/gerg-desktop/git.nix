{ pkgs, config }:
{
  programs.git = {
    enable = true;
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
      gpg = {
        format = "ssh";
        ssh.defaultKeyCommand = pkgs.writeShellScript "git_key" ''
          if ssh-add -L | grep -vq '${config.local.keys.gerg_gerg-desktop}'; then
            ssh-add -t 1m ~/.ssh/id_ed25519
          fi
          echo 'key::${config.local.keys.gerg_gerg-desktop}'
        '';
      };
      push.gpgsign = "if-asked";
      commit.gpgsign = true;
    };
  };
}
