{pkgs, ...}: let
  vim-moonfly = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-moonfly";
    version = "1.0.0";
    src = pkgs.fetchFromGitHub {
      owner = "bluz71";
      repo = "vim-moonfly-colors";
      rev = "ae3db6fe9a6d8ee6b22e28a19754a721d777df44";
      sha256 = "sha256-2EUkTrPVERGmyWfq1a41xYCNHjFVUSrPUsYkWY9Igyc=";
    };
  };
in {
  # home.packages = with pkgs; [rustc cargo rust-analyzer clang-tools];
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraPackages = with pkgs; [gcc ripgrep fd];
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
      rainbow
      nvim-ts-rainbow # rainbow for tree-sitter
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
