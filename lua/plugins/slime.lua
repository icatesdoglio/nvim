-- Pseudocode
-- If in normal mode, we want to
--	enter visual mode
--	select relevant chunk of code
--	Send relevant chunk to terminal -- Should be handled by :SlimeSend in visual mode?
--	exit normal mode
--	send cursor to bottom of the relevant chunk
--
local function visual_slime()
	--
	--
	-- Same key mapping in visual mode should send selected text to the terminal
	print("Ctrl-Enter")
end

return {
	"jpalardy/vim-slime",
	--keys = {
	--	{
	--		"C-CR",
	--		function()
	--			require("vim-slime")
	--			return ":SlimeSend<CR>"
	--		end,
	--		desc = "Send to ipython",
	--	},
	--},
	config = function()
		vim.keymap.set("x", "<leader>-bb", "<cmd>echo Hello!<CR>", { noremap = true })
	end,
}
