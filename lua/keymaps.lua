-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- NAVIGATION
-- Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')
-- Disable arrow keys in insert mode
vim.keymap.set("i", "<left>", '<cmd>echo "Use normal mode to navigate"<CR>')
vim.keymap.set("i", "<right>", '<cmd>echo "Use normal mode to navigate"<CR>')
vim.keymap.set("i", "<up>", '<cmd>echo "Use normal mode to navigate"<CR>')
vim.keymap.set("i", "<down>", '<cmd>echo "Use normal mode to navigate"<CR>')

-- Center screen when moving around
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")

-- Swap rows in visual mode
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- For Obsidian
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.wo.conceallevel = 2
	end,
})

-- Alter tabs
vim.keymap.set("n", ">", "V><esc>")
vim.keymap.set("n", "<", "V<<esc>")

-- Format yanked text for python format:
local function format_to_python()
	local lines = vim.fn.getreg("+", 1, true)
	local leading_whitespace = lines[1]:match("^(%s*)%S")

	if leading_whitespace == nil then
		return
	end
	leading_whitespace = #leading_whitespace

	for i, line in ipairs(lines) do
		lines[i] = line:sub(leading_whitespace + 1)
	end

	local out = table.concat(lines, "\n")

	vim.notify("Formatted system register for python repl")
	vim.fn.setreg("+", out)
end

local function send_to_repl()
	local file_loc = "c:/Users/icates-doglio/AppData/Local/nvim/ahk_scripts/send_to_repl.ahk"
	os.execute('start "" Autohotkey "' .. file_loc .. '"')
end

vim.keymap.set("v", "<leader>yr", function()
	vim.cmd('normal! "+y')
	format_to_python()
end, { noremap = true, silent = true })

vim.keymap.set("v", "<leader>yp", function()
	vim.cmd('normal! "+y')
	format_to_python()
	send_to_repl()
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>v", function()
	format_to_python()
	send_to_repl()
end, { noremap = true, silent = true })

--function Operator_yank(type)
--	-- Perform the yank operation in operator-pending mode
--	print("I've been executed")
--	vim.cmd("normal! `[v`]" .. type)
--	format_to_python()
--end
--
---- Map `leader-y` as an operator
--vim.keymap.set("n", "<leader>y", function()
--	vim.o.operatorfunc = "v:lua.Operator_yank"
--end, { noremap = true })

-- Cycle through quickfix list
vim.keymap.set("n", "<leader>[", ":cprev<CR>")
vim.keymap.set("n", "<leader>]", ":cnext<CR>")

-- Re-source snippets
vim.keymap.set("n", "<leader><leader>s", function()
	require("luasnip").cleanup()
	dofile(vim.fn.stdpath("config") .. "/lua/plugins/custom_snippets.lua")
	print("Snippets reloaded!")
end, { noremap = true, silent = true })

-- vim: ts=2 sts=2 sw=2 et
