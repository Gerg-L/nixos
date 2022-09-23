{pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraPackages = with pkgs; [gcc ripgrep fd];
    plugins = with pkgs.vimPlugins; [
      (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars)) #syntax highlighting
      rainbow nvim-ts-rainbow # rainbow for tree-sitter
      nvim-colorizer-lua # colors
      nvim-tree-lua # file browser
      nvim-web-devicons # for tree-lua
      vim-smoothie #smooth scrolling
      undotree # better undotree
      indentLine # indentlines
      vim-smoothie #smooth scrolling
      #non-trash auto completion
      nvim-cmp
      cmp-buffer
      cmp-nvim-lsp
      cmp-path
      cmp-spell
      cmp-treesitter
      cmp-vsnip
      vim-vsnip
      lspkind-nvim
      nvim-lspconfig
      nvim-autopairs # auto brackets
      telescope-nvim #search feature
      telescope-fzy-native-nvim # search plugin
      gitsigns-nvim #in buffer git blame
      vim-moonfly #color scheme
      lightline-vim #bottom bar
    ];
    extraConfig = let
  luaRequire = module:
    builtins.readFile (builtins.toString
      ./config
      + "/${module}.lua");
  luaConfig = builtins.concatStringsSep "\n" (map luaRequire [
    "init"
    "lspconfig"
    "nvim-cmp"
  ]);
in ''
lua << EOF
${luaConfig}
EOF

'';
  };
}

