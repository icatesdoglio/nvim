-- Lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end ---@diagnostic disable-next-line: undefined-field

vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
	require("plugins.theme"),
	require("plugins.basic"),
	require("plugins.telescope"),
	require("plugins.whichkey"),
	require("plugins.lazydev"),
	require("plugins.lspconfig"),
	require("plugins.blink_cmp"),
	require("plugins.harpoon"),
	require("plugins.undotree"),
	require("plugins.treesitter"),
	require("plugins.textobjects"),
	require("plugins.oil"),
	require("plugins.obsidian"),
	require("plugins.sql"),
	ui = {
		icons = vim.g.have_nerd_font and {},
	},
})

function LineNumberColors()
	vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#BB9AF7", bold = true })
	vim.api.nvim_set_hl(0, "LineNr", { fg = "#FFA500", bold = true })
	vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#F5BDE6", bold = true })
end
LineNumberColors()

vim.api.nvim_set_hl(0, "ColorColumn", { ctermbg = 0, bg = "#3A3A80" })
--"palette": {
--  "blue": "#8AADF4",
--  "closer": "p:os",
--  "lavender": "#BB9AF7",
--  "orange": "#FFA500",
--  "os": "#ACB0BE",
--  "pink": "#F5BDE6"
--}

-- vim: ts=2 sts=2 sw=2 et
