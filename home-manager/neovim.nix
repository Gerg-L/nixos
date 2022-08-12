{pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
    coc = {
      enable = true;
      package = pkgs.vimPlugins.coc-nvim;
    };
    plugins = with pkgs.vimPlugins; [
      vim-smoothie #smooth scrolling
      tokyonight-nvim #color scheme
      undotree # better undos
      #extra stuff
      nvim-tree-lua # file browser
      nvim-web-devicons # for tree-lua
#      telescope-nvim # file finder
      indentLine # indentlines
      nvim-treesitter #syntax highlighting
    ];
    extraConfig = "lua << EOF\n" + builtins.readFile ./init.lua + "\nEOF";
  };
}
