{ pkgs }:
{
  users.defaultUserShell = pkgs.zsh;
  programs = {
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      histSize = 20000;
      histFile = "$HOME/.cache/zsh_history";
      interactiveShellInit = ''
          ### zsh-history-substring-search ###
          setopt HIST_IGNORE_ALL_DUPS
          source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
          bindkey '^[[A' history-substring-search-up
          bindkey '^[[B' history-substring-search-down
          ### fzf-tab ###
          source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
          ### transient shell prompt ###
          zle-line-init() {
          emulate -L zsh

          [[ $CONTEXT == start ]] || return 0

          while true; do
            zle .recursive-edit
            local -i ret=$?
           [[ $ret == 0 && $KEYS == $'\4' ]] || break
           [[ -o ignore_eof ]] || exit 0
          done

         local saved_prompt=$PROMPT
          local saved_rprompt=$RPROMPT
          PROMPT='\$ '
          RPROMPT='''
          zle .reset-prompt
          PROMPT=$saved_prompt
          RPROMPT=$saved_rprompt

          if (( ret )); then
            zle .send-break
          else
            zle .accept-line
          fi
          return ret
        }

        zle -N zle-line-init
      '';
    };

  };
}
