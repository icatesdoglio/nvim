return {
	"folke/tokyonight.nvim",
	priority = 1000,
	init = function()
		vim.cmd.colorscheme("tokyonight-night")
		vim.cmd.hi("Comment gui=none")
	end,
	opts = {
		style = "night", -- or "storm", "day", "moon"
		on_colors = function(colors)
			colors.comment = "#EECCDD"
		end,
	},
}
-- vim: ts=2 sts=2 sw=2 et
