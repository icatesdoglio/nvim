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

		completion = { documentation = { auto_show = true },

		menu = {
			draw = {
				components = {
					kind_icon = {
						text = function(ctx)
							-- Sources (azure_boards, github_issues) can set item.kind_icon
							-- directly to override the default mini.icons lookup.
							if ctx.item.kind_icon then
								return ctx.item.kind_icon
							end
							local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
							return kind_icon
						end,
						highlight = function(ctx)
							if ctx.item.kind_hl then
								return ctx.item.kind_hl
							end
							local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
							return hl
						end,
					},
					kind = {
						highlight = function(ctx)
							if ctx.item.kind_hl then
								return ctx.item.kind_hl
							end
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
				local ft = vim.bo.filetype
				local is_git_buffer = ft:match("^git") ~= nil
					or ft:match("^Neogit") ~= nil
					or ft == "fugitive"
				if ft == "sql" then
					return { "lsp", "path", "buffer" }
				elseif is_git_buffer then
					return { "lsp", "path", "buffer", "conventional_commits", "azure_boards", "github_issues" }
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
			azure_boards = {
				name = 'Azure Boards',
				module = 'azure_boards',
				enabled = function()
					return require('azure_boards').is_git_buffer()
				end,
			},
			github_issues = {
				name = 'GitHub Issues',
				module = 'github_issues',
				enabled = function()
					return require('github_issues').is_git_buffer()
				end,
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
	config = function(_, opts)
		-- Custom kind highlights for the azure_boards / github_issues completion
		-- items (see their item.kind_hl). `default = true` lets a colorscheme
		-- override these; re-applied on ColorScheme since most colorschemes
		-- clear custom highlights on load.
		local function set_kind_highlights()
			vim.api.nvim_set_hl(0, "BlinkCmpKindAzureBoards", { link = "DiagnosticInfo", default = true })
			vim.api.nvim_set_hl(0, "BlinkCmpKindGithubIssue", { link = "String", default = true })
		end
		set_kind_highlights()
		vim.api.nvim_create_autocmd("ColorScheme", { callback = set_kind_highlights })

		require("blink.cmp").setup(opts)
		require("azure_boards").setup_vt()
		require("github_issues").setup_vt()
	end,
}

-- vim: ts=2 sts=2 sw=2 et
