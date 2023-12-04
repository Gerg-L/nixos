{fetch-rs, ...}:
{
  pkgs,
  config,
  lib,
  ...
}:
{
  systemd.tmpfiles.rules = ["d /tmp/neovim-page 0777 root root - -"];
  environment = {
    systemPackages = builtins.attrValues {
      inherit (pkgs) page eza fzf;
      inherit (fetch-rs.packages) fetch-rs;
    };
    binsh = lib.getExe pkgs.dash; # use dash for speed
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      PAGER = "page -WC -q 90000 -z 90000";
      SYSTEMD_PAGERSECURE = "true";
      MANPAGER = "page -t man";
    };
    shellAliases = {
      #make sudo use aliases
      sudo = "sudo ";
      #paste link trick
      pastebin = "curl -F 'clbin=<-' https://clbin.com";
      termbin = "nc termbin.com 9999";
      #nix stuff
      gc-check = ''nix-store --gc --print-roots | egrep -v "^(/nix/var|/run/w+-system|{memory|/proc)"'';
      #vim stuff
      vi = "nvim";
      vim = "nvim";
      vimdiff = "nvim -d";
      #eza is 1 too many letters
      ls = "eza";
      l = "eza -lbF --git";
      ll = "eza -lbGF --git";
      llm = "eza -lbGd --git --sort=modified";
      la = "eza -lbhHigUmuSa --time-style=long-iso --git --color-scale";
      lx = "eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale";
      lS = "eza -1";
      lt = "eza --tree --level=2";
      page = config.environment.variables.PAGER;
    };
    interactiveShellInit = "fetch-rs";
  };
  security.sudo = {
    enable = true;
    execWheelOnly = true;
    extraConfig = ''
      Defaults env_keep += "${
        builtins.concatStringsSep " " (builtins.attrNames config.environment.variables)
      }"
      Defaults lecture = never
    '';
  };

  #zsh stuff
  users.defaultUserShell = pkgs.zsh;
  programs = {
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      histSize = 10000;
      histFile = "$HOME/.cache/zsh_history";
      interactiveShellInit = ''
          ### fzf-tab ###
          source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
          ### pager ###
          man () {
            PROGRAM="''${@[-1]}"
            SECTION="''${@[-2]}"
            page -W "man://$PROGRAM''${SECTION:+($SECTION)}"
          }
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
    #starship
    starship = {
      enable = true;
      settings = {
        add_newline = false;
        format = ''
          $cmd_duration$git_metrics$git_state$git_branch
          $status$directory$character'';
        right_format = "$sudo$nix_shell\${custom.direnv} $time";
        continuation_prompt = "▶▶ ";
        character = {
          success_symbol = "[\\$](#9ece6a bold)";
          error_symbol = "[\\$](#db4b4b bold)";
        };
        status = {
          disabled = false;
          format = "[$status]($style) ";
        };
        nix_shell = {
          format = "[󱄅 ](#74b2ff)";
          heuristic = true;
        };
        directory = {
          read_only = " ";
        };
        git_metrics = {
          disabled = false;
        };
        git_branch = {
          format = "[$symbol$branch(:$remote_branch)]($style)";
          style = "bold red";
        };
        sudo = {
          format = "[ ](#7aa2f7)";
          disabled = false;
        };
        cmd_duration = {
          min_time = 5000;
          style = "bold #9ece6a";
        };
        custom.direnv = {
          format = "[\\[direnv\\]]($style)";
          style = "#36c692";
          when = "printenv DIRENV_FILE";
        };
        time = {
          format = ''
            [$time]($style)
          '';
          time_format = "%I:%M %p";
          disabled = false;
        };
      };
    };
  };
  _file = ./shell.nix;
}
