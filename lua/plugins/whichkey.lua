return {
	{
		"folke/which-key.nvim",
		event = "VimEnter",
		opts = {
			icons = {
				mappings = vim.g.have_nerd_font,
				keys = vim.g.have_nerd_font and {},
			},
			spec = {
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>h", group = "[H]arpoon", mode = { "n", "v" } },
			},
		},
	},
}

-- vim: ts=2 sts=2 sw=2 et
