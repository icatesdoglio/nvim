--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Modules
require("options")

require("keymaps")

require("lazy-plugins")

require("nvim-treesitter.install").compilers = { "clang" }

-- adjustments to the Color Scheme
-- Add custom line number colors
vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#BB9AF7", bold = false })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#FFA500", bold = false })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#F5BDE6", bold = false })
-- 80 character mark
vim.api.nvim_set_hl(0, "ColorColumn", { ctermbg = 0, bg = "#3A3A80" })

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    local current = vim.api.nvim_get_hl(0, { name = "Folded" })
    vim.api.nvim_set_hl(0, "Folded", {
      bg = "NONE",
    })
  end,
})
--"palette": {
--  "blue": "#8AADF4",
--  "closer": "p:os",
--  "lavender": "#BB9AF7",
--  "orange": "#FFA500",
--  "os": "#ACB0BE",
--  "pink": "#F5BDE6"
--}

-- vim: ts=2 sts=2 sw=2 et
