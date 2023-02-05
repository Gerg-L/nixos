{
  pkgs,
  lib,
  ...
}: rec {
  environment = {
    systemPackages = with pkgs; [
      dash
      neovim
      page
      zsh
      st
      exa
      fetch-rs
    ];
    binsh = "${pkgs.dash}/bin/dash"; #use dash for speed
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      PAGER = "page";
      SYSTEMD_PAGERSECURE = "true";
      TERMINAL = "st";
      NIX_BUILD_SHELL = "zsh";
    };
    shellAliases = {
      #make sudo use aliases
      sudo = "sudo ";
      #paste link trick
      pastebin = "curl -F 'clbin=<-' https://clbin.com";
      #nix stuff
      update = "nix flake update /etc/nixos/#";
      switch = "nixos-rebuild switch";
      boot = "nixos-rebuild boot";
      clean = "nix-collect-garbage -d";
      gc-force = "rm /nix/var/gcroots/auto/*";
      gc-check = "find -H /nix/var/nix/gcroots/auto -type l | xargs -I {} sh -c 'readlink {}; realpath {}; echo' | page";
      #vim stuff
      vi = "nvim";
      vim = "nvim";
      vimdiff = "nvim -d";
      #exa is 1 too many letters
      ls = "exa";
      l = "exa -lbF --git";
      ll = "exa -lbGF --git";
      llm = "exa -lbGd --git --sort=modified";
      la = "exa -lbhHigUmuSa --time-style=long-iso --git --color-scale";
      lx = "exa -lbhHigUmuSa@ --time-style=long-iso --git --color-scale";
      lS = "exa -1";
      lt = "exa --tree --level=2";
    };
    interactiveShellInit = "fetch-rs";
  };
  security.sudo = {
    enable = true;
    execWheelOnly = true;
    extraConfig = ''
      Defaults env_keep += "${builtins.concatStringsSep " " (builtins.attrNames environment.variables)}"
    '';
  };

  #zsh stuff
  users.defaultUserShell = pkgs.zsh;
  environment.shells = [pkgs.zsh];
  programs = {
    zsh = {
      enable = true;
      autosuggestions = {
        enable = true;
      };
      syntaxHighlighting = {
        enable = true;
      };
    };
    #starship
    starship = {
      enable = true;
      settings = {
        add_newline = false;
        format = "$sudo$cmd_duration \n $directory$git_branch$character";
        character = {
          success_symbol = "[ ](#9ece6a bold)";
          error_symbol = "[ ](#db4b4b bold)";
        };
        directory = {
          read_only = " ";
        };
        git_branch = {
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
      };
    };
  };
}
