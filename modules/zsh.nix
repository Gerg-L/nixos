{
  programs = {
    zsh = {
      enable = true;
      autosuggestions = {
        enable = true;
      };
      syntaxHighlighting = {
        enable = true;
      };
      interactiveShellInit = "neofetch";
      shellAliases = {
        ls = "exa --long --icons";
      };
    };
    starship = {
      enable = true;
      settings = {
        add_newline = false;
        format="$sudo \n $directory$git_branch$character";
        character = {
          success_symbol = "[](#9ece6a bold)";
          error_symbol = "[](#db4b4b bold)";
        };
        directory = {
          read_only = " ";
        };
        git_branch = {
          style = "bold red";
        };
        sudo ={
        format = "[ ](#7aa2f7)";
        disabled = false;
        };
      };
    };
  };
}
