return {
	"saghen/blink.cmp",
	dependencies = {
		"disrupted/blink-cmp-conventional-commits"
	},
	version = "1.*",
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = {
			preset = "default",
			-- Hotkey to show the commands
			['<C-l>'] = { function(ctx) require("blink-cmp").show() end}
		},
		appearance = {
			nerd_font_variant = "mono",
		},

		-- (Default) Only show the documentation popup when manually triggered
		completion = { documentation = { auto_show = false },

		menu = {
			draw = {
				components = {
					kind_icon = {
						text = function(ctx)
							local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
							return kind_icon
						end,
						-- (optional) use highlights from mini.icons
						highlight = function(ctx)
							local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
							return hl
						end,
					},
					kind = {
						-- (optional) use highlights from mini.icons
						highlight = function(ctx)
							local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
							return hl
						end,
					}
				}
			}
		}
	},

		-- Default list of enabled providers defined so that you can extend it
		-- elsewhere in your config, without redefining it, due to `opts_extend`
		sources = {
			default = function()
				if vim.bo.filetype == "sql" then
					return { "lsp", "path", "buffer" }
				elseif vim.bo.filetype == "gitcommit" then
					return { "lsp", "path", "buffer", "conventional_commits" }
				else
					return { "lsp", "path", "buffer"}
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
			path = {
				opts = {
					get_cwd = function(_)
						return vim.fn.getcwd()
					end,
				},
			},
		},
		},

    fuzzy = { implementation = "prefer_rust_with_warning" },
    signature = { enabled = true }, 
	},
	opts_extend = { "sources.default" },
}

-- vim: ts=2 sts=2 sw=2 et
