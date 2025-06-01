return {
	"tpope/vim-sleuth",
  -- ##################################
  ----------------STATUSLINE-----------
  -- ##################################
	{
		"echasnovski/mini.nvim",
		config = function()
			require("mini.ai").setup({ n_lines = 500 })
			require("mini.surround").setup()

			local statusline = require("mini.statusline")
			statusline.setup({ use_icons = vim.g.have_nerd_font })

			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return "%2l:%-2v"
			end
		end,
	},
  -- ##################################
  ----------------LUA------------------
  -- ##################################
	{ "Bilal2453/luvit-meta", lazy = true },
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
  -- ##################################
  ----------------GIT------------------
  -- ##################################
	{
		"tpope/vim-fugitive",
		cmd = { "Git", "Gvdiffsplit" },
  },
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
  -- ##################################
  ----------------UNDOS----------------
  -- ##################################
  {
    "mbbill/undotree",
    lazy = true,
    cmd = { "<leader>u" },
    {
      vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle),
    },
  },
  -- ##################################
  ----------------FILETREE-------------
  -- ##################################
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    dependencies = { "echasnovski/mini.icons" },
  },
  -- ##################################
  -----------------THEME---------------
  -- ##################################
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    init = function()
      vim.cmd.colorscheme("tokyonight-night")
      vim.cmd.hi("Comment gui=none")
    end,
    opts = {
      style = "night", 
      on_colors = function(colors)
        colors.comment = "#EECCDD"
      end,
    },
  }
}

-- vim: ts=2 sts=2 sw=2 et
