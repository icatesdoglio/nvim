--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- lua/options
require("options")

require("keymaps")

require("lazy-bootstrap")

require("lazy-plugins")

require("nvim-treesitter.install").compilers = { "clang" }

-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

-- LSP Plugins

--{
--	"nvim-treesitter/nvim-treesitter",
--},
--	{ -- Highlight, edit, and navigate code
--		"nvim-treesitter/nvim-treesitter",
--		build = ":TSUpdate",
--		main = "nvim-treesitter.configs", -- Sets main module to use for opts
--		-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
--		opts = {
--			ensure_installed = {
--				"bash",
--				"c",
--				"diff",
--				"html",
--				"lua",
--				"luadoc",
--				"markdown",
--				"markdown_inline",
--				"query",
--				"vim",
--				"vimdoc",
--			},
--			-- Autoinstall languages that are not installed
--			auto_install = true,
--			highlight = {
--				enable = true,
--				-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
--				--  If you are experiencing weird indenting issues, add the language to
--				--  the list of additional_vim_regex_highlighting and disabled languages for indent.
--				additional_vim_regex_highlighting = { "ruby" },
--			},
--			indent = { enable = true, disable = { "ruby" } },
--		},
--		-- There are additional nvim-treesitter modules that you can use to interact
--		-- with nvim-treesitter. You should go explore a few and see what interests you:
--		--
--		--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
--		--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
--		--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
--	},
