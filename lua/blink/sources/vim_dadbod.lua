-- lua/blink/sources/vim_dadbod.lua
local M = {}

M.complete = function(ctx)
	local matches = vim.fn["vim_dadbod_completion#omni"](1, ctx.prefix) or {}
	local items = {}

	for _, match in ipairs(matches) do
		table.insert(items, {
			label = match,
			kind = "Field",
		})
	end

	return items
end

return M
