return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("harpoon"):setup()
	end,
	key = function()
		return vim.loop.cwd()
	end,
	keys = {
		{
			"<leader>ha",
			function()
				require("harpoon"):list():add()
			end,
			desc = "[H]arpoon [A]dd",
		},
		{
			"<leader>hm",
			function()
				local harpoon = require("harpoon")
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end,
			desc = "[H]arpoon [M]enu",
		},
		{
			"<leader>hs",
			function()
				require("harpoon"):list():select(1)
			end,
			desc = "[H]arpoon to [1]",
		},
		{
			"<leader>hd",
			function()
				require("harpoon"):list():select(2)
			end,
			desc = "[H]arpoon to [2]",
		},
		{
			"<leader>hf",
			function()
				require("harpoon"):list():select(3)
			end,
			desc = "[H]arpoon to [3]",
		},
		{
			"<leader>hg",
			function()
				require("harpoon"):list():select(4)
			end,
			desc = "[H]arpoon to [4]",
		},
		{
			"<leader>hh",
			function()
				require("harpoon"):list():select(5)
			end,
			desc = "[H]arpoon to [5]",
		},
	},
}

-- vim: ts=2 sts=2 sw=2 et
