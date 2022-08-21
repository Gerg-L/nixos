{pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
    plugins = with pkgs.vimPlugins; [
      vim-smoothie #smooth scrolling
      tokyonight-nvim #color scheme
      undotree # better undos
      #extra stuff
      nvim-tree-lua # file browser
      nvim-web-devicons # for tree-lua
#      telescope-nvim # file finder
      indentLine # indentlines
      (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars)) #syntax highlighting
      coq_nvim # autocompletions
    ];
    extraConfig = "lua << EOF\n" + builtins.readFile ./init.lua + "\nEOF";
    
  };
}
