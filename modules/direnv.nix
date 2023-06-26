_: {pkgs, ...}: {
  environment = {
    systemPackages = [pkgs.direnv];
    variables = {
      DIRENV_LOG_FORMAT = "";
      DIRENV_CONFIG = "/etc/direnv";
    };
    etc."direnv/direnvrc".text = ''
      source ${pkgs.nix-direnv}/share/nix-direnv/direnvrc
      if [ -e $HOME/.config/direnv/direnvrc ] ; then
        source $HOME/.config/direnv/direnvrc
      fi
    '';
  };
  programs = {
    zsh.interactiveShellInit = ''
      if [[ -o interactive ]] && ! printenv PATH | grep -qc '/nix/store' && [ -z "$IN_NIX_SHELL" ] ; then
        eval "$(direnv hook zsh)"
      fi
    '';
    bash.interactiveShellInit = ''
      if [ $- == *i* ] && ! printenv PATH | grep -qc '/nix/store' && [ -z "$IN_NIX_SHELL" ] ; then
        eval "$(direnv hook bash)"
      fi
    '';
    #   fish.enable = true;
    #   fish.interactiveShellInit = ''
    #     if status --is-interactive; and not printenv PATH | grep -qc '/nix/store'; and  [ -z "$IN_NIX_SHELL" ];
    #       direnv hook fish | source;
    #       echo "loaded direnv";
    #     end
    #   '';
  };
}
