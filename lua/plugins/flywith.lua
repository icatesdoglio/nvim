local settings
if vim.uv.cwd():match("FlyWithLua") then
	-- Settings for FlyWithLua files
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT", -- FlyWithLua uses LuaJIT
			},
			diagnostics = {
				globals = {
					-- Add FlyWithLua-specific globals
					"XPLMFindDataRef",
					"XPLMGetDataf",
					"XPLMSetDataf",
					"XPLMFindCommand",
					"XPLMCommandOnce",
					"XPLMCommandBegin",
					"draw_string",
					"do_every_frame",
					"do_on_new_XPLM_command",
					"DataRef",
				},
			},
			workspace = {
				library = {
					vim.fn.expand("c:/Games/Steam/steamapps/common/X-Plane 11/Resources/plugins/FlyWithLua/Modules"),
				},
				checkThirdParty = false,
			},
		},
	}
else
	-- Default Lua settings (for VimLua or general Lua)
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
		},
	}
end

return settings
-- vim: ts=2 sts=2 sw=2 et
