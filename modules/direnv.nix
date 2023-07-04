_: {pkgs, ...}: {
  environment = {
    systemPackages = [pkgs.direnv];
    variables = {
      DIRENV_LOG_FORMAT = "";
      DIRENV_CONFIG = "/etc/direnv";
    };
    #other direnv configuration goes here
    etc."direnv/direnvrc".text = ''
      source ${pkgs.nix-direnv}/share/nix-direnv/direnvrc
    '';
  };
  programs = {
    zsh.interactiveShellInit = ''
      if ! printenv PATH | grep -qc '/nix/store' && [ -z "$IN_NIX_SHELL" ] ; then
        eval "$(direnv hook zsh)"
      fi
    '';
    bash.interactiveShellInit = ''
      if [[ $- == *i* ]] && ! printenv PATH | grep -qc '/nix/store' && [ -z "$IN_NIX_SHELL" ] ; then
        eval "$(direnv hook bash)"
      fi
    '';
  };
}
