_: {pkgs, ...}: {
  environment = {
    systemPackages = builtins.attrValues {
      inherit
        (pkgs)
        nix-direnv
        direnv
        ;
    };

    variables = {
      DIRENV_LOG_FORMAT = "";
      DIRENV_CONFIG = "${pkgs.nix-direnv}/share/nix-direnv";
    };
  };
  programs = {
    zsh.interactiveShellInit = ''
      eval "$(direnv hook zsh)"
    '';
    bash.interactiveShellInit = ''
      eval "$(direnv hook bash)"
    '';
    fish.interactiveShellInit = ''
      direnv hook fish | source
    '';
  };
}
