-- settings
-- keybind modifier
vim.g.mapleader = "'"
vim.opt.updatetime = 300
vim.opt.incsearch = true
-- backups bad
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
--formatting
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
-- pretty numbers
vim.opt.signcolumn = "yes:2"
vim.opt.number = true
vim.opt.relativenumber = true
-- mouse 
vim.opt.mouse = "a"
-- no wrapping bs
vim.wo.wrap = false
-- dark background
vim.opt.background = "dark"
vim.opt.termguicolors = true
-- hide bottom bar for lightling
vim.g.noshowmode = true
-- stop hiding double quotes in json files
vim.g.indentLine_setConceal = 0
-- plugin setups
-- file expolorer
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1
require("nvim-tree").setup {
  open_on_setup = false,
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
  },
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
}
require("nvim-web-devicons").setup()
-- language support
 require("nvim-treesitter.configs").setup {
  ensure_installed = "",
	sync_install = true,
	auto_install = false,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false
	},
	rainbow = {
		enable = true,
		extended_mode = true,
		max_file_lines = nil,
	},
}
-- shapes and colors
vim.cmd[[colorscheme moonfly]]
-- pretty colors
require("colorizer").setup()
require("telescope").load_extension("fzy_native")
require("gitsigns").setup {
  current_line_blame = true,
}
require("nvim-autopairs").setup()

-- telescope keybinds
vim.keymap.set( "n", "<Leader>s", "<cmd>Telescope find_files<cr>")
-- show tree
vim.keymap.set("n", "<Leader>t", ":NvimTreeToggle<CR>")

-- lightnline load colorscheme
vim.g.lightline = { colorscheme = "moonfly" }
