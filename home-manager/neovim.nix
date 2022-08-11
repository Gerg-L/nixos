{ pkgs, ... }:
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
      vim-nix
      vim-polyglot
      vim-smoothie
      nvim-tree-lua
      nvim-web-devicons
      tokyonight-nvim
      rainbow
      indentLine
      undotree
    ];
    extraConfig = ''
      :lua require("nvim-tree").setup()
      set tabstop=2
      set expandtab
      set shiftwidth=2
      set ignorecase
      set incsearch
      set number 
      set noswapfile
      let mapleader = "'"
    '';
  };
}
