{
  fetch-rs,
  pkgs,
}:
{
  local.packages = {
    inherit (pkgs) eza fzf;
    inherit (fetch-rs.packages) fetch-rs;
  };
  environment = {
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    shellAliases = {
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
    };
    interactiveShellInit = "fetch-rs";
  };

  programs.starship = {
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
      sudo = {
        format = "[ ](#7aa2f7)";
        disabled = false;
      };
    };
  };
}
