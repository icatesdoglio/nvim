return {
	"saghen/blink.cmp",
	dependencies = {
		"rafamadriz/friendly-snippets",
		"disrupted/blink-cmp-conventional-commits"
	},
	version = "1.*",
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = { 
			preset = "default",
			['C-space'] = { function(cmp) cmp.show({providers = {'buffer'} }) end}
		},
		appearance = {
			nerd_font_variant = "mono",
		},

		-- (Default) Only show the documentation popup when manually triggered
		completion = { documentation = { auto_show = false } },

		-- Default list of enabled providers defined so that you can extend it
		-- elsewhere in your config, without redefining it, due to `opts_extend`
		sources = {
			default = function()
				if vim.bo.filetype == "sql" then
					return { "lsp", "path", "buffer", "snippets", "dadbod" }
				elseif vim.bo.filetype == "gitcommit" then
					return { "lsp", "path", "buffer", "snippets", "conventional_commits" }
				else
					return { "lsp", "path", "snippets", "buffer"}
				end
			end,
		providers = {
			conventional_commits = {
				name = 'Conventional Commits',
				module = 'blink-cmp-conventional-commits',
				enabled = function()
					return vim.bo.filetype == 'gitcommit'
				end,
				---@module 'blink-cmp-conventional-commits'
				---@type blink-cmp-conventional-commits.Options
				opts = {},
			},
		},
		},

		-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
		-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
		-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
		--
		-- See the fuzzy documentation for more information
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}
