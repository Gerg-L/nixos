local g = vim.g
local o = vim.o
-- settings
-- keybind modifier
g.mapleader = "'"
o.updatetime = 300
o.incsearch = true
-- backups bad
o.swapfile = false
o.backup = false
o.writebackup = false
--formatting
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
-- pretty numbers
o.signcolumn = "number"
o.number = true
--easy keybinds
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end
-- show tree
map("n", "<Leader>t", ":NvimTreeToggle<CR>")
-- coc completion
map("i", "<cr>", 'pumvisible() ? coc#_select_confirm() : \"\\<C-g>u\\<CR>\"', {silent = true, expr = true})

-- plugin setups
require("nvim-tree").setup {
  open_on_setup = true,
  sort_by = "case_sensitive",
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
}
require("nvim-web-devicons").setup()
require("nvim-treesitter.configs").setup {
  ensure_installed = "all",
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false
  }
}

