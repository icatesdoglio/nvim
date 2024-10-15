--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro"

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Modules
require("options")

require("keymaps")

require("lazy-plugins")

require("nvim-treesitter.install").compilers = { "clang" }
