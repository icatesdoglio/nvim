local CURSOR_DIAG_NS = vim.api.nvim_create_namespace("cursor_diagnostics")

return {
	-- Main LSP Configuration
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "j-hui/fidget.nvim", opts = {} },
		"saghen/blink.cmp",
	},
	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end
				map("gr", vim.lsp.buf.rename, "[R]e[n]ame")
				map("ga", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
				map("gR", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
				map("gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
				map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
				map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")
				map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
				map("gt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")
				---@param client vim.lsp.Client
				---@param method vim.lsp.protocol.Method
				---@param bufnr? integer some lsp support methods only in specific files
				---@return boolean
				local function client_supports_method(client, method, bufnr)
          return client:supports_method(method, bufnr)
				end
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if
					client
					and client_supports_method(
						client,
						vim.lsp.protocol.Methods.textDocument_documentHighlight,
						event.buf
					)
				then
					local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
						end,
					})
				end
				if
					client
					and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
				then
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, "[T]oggle Inlay [H]ints")
				end
			end,
		})
		vim.diagnostic.config({
			severity_sort = true,
			float = { border = "rounded", source = "if_many" },
      underline = { severity = vim.diagnostic.severity.ERROR 
      or vim.diagnostic.severity.WARN},
      signs = true and {
				text = {
					[vim.diagnostic.severity.ERROR] = "󰅚 ",
					[vim.diagnostic.severity.WARN] = "󰀪 ",
					[vim.diagnostic.severity.INFO] = "󰋽 ",
					[vim.diagnostic.severity.HINT] = "󰌶 ",
				},
			},
			virtual_text = {
				source = "if_many",
				spacing = 2,
				format = function(diagnostic)
					local diagnostic_message = {
						[vim.diagnostic.severity.ERROR] = diagnostic.message,
						[vim.diagnostic.severity.WARN] = diagnostic.message,
					}
					return diagnostic_message[diagnostic.severity]
				end,
			},
    })


    -- Show diagnostics only for the current line as virtual text
    vim.api.nvim_create_autocmd("CursorHold", {
      callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        local line = vim.api.nvim_win_get_cursor(0)[1] - 1
        local diagnostics = vim.diagnostic.get(bufnr, {
          lnum = line,
          severity = {
            min = vim.diagnostic.severity.HINT,
            max = vim.diagnostic.severity.INFO,
          },
        })

        if #diagnostics > 0 then
          vim.diagnostic.show(CURSOR_DIAG_NS, bufnr, diagnostics, {
            virtual_text = {
              spacing = 2,
              format = function(d)
                return d.message
              end,
            },
            signs = false,
            underline = false,
          })
        end
      end,
    })

    vim.api.nvim_create_autocmd("CursorMoved", {
      callback = function()
        vim.diagnostic.hide(CURSOR_DIAG_NS, vim.api.nvim_get_current_buf())
      end,
    })

		local capabilities = require("blink.cmp").get_lsp_capabilities()
		local servers = {
			pyright = {
				settings = {
					Python = {
						completion = {
							callSnippet = "Replace",
						},
						diagnostics = {},
					},
				},
			},
			rust_analyzer = {},
			lua_ls = {
				-- cmd = {...},
				-- filetypes = { ...},
				-- capabilities = {},
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			},
			r_language_server = {
				cmd = {
					"R",
					"--slave",
					"-e",
					"languageserver::run()",
				},
				filetypes = { "r", "rmd", "rmarkdown" },
				capabilities = {
					textDocument = {
						completion = { completionItem = { snippetSupport = true } },
					},
				},
				settings = {
					R = {
						lsp = {
							diagnostics = {
								suppress = { "line_length_linter" },
							},
						},
						-- path = "C:/Users/icates-doglio/AppData/Local/Programs/R/R-4.4.0/",
						-- library = "C:/Users/icates-doglio/AppData/Local/Programs/R/R-4.4.0/library",
					},
				},
			},
		}
		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			"stylua",
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		require("mason-lspconfig").setup({
			ensure_installed = {},
			automatic_installation = false,
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})
	end,
}
-- vim: ts=2 sts=2 sw=2 et
