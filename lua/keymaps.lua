CONF = os.getenv("XDG_CONFIG_HOME")
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

local function visual_selection()
	local _, ls, cs = unpack(vim.fn.getpos("'<")) -- Start position
	local _, le, ce = unpack(vim.fn.getpos("'>")) -- End position

	-- Convert from 1-based to 0-based indexing
	ls, cs = ls - 1, cs - 1
	le, ce = le - 1, ce

	local lines = vim.api.nvim_buf_get_text(0, ls, cs, le, ce, {})
	return lines
end

-- Format table of text to python repl format:
local function format_to_python(tab)
	local leading_whitespace = tab[1]:match("^(%s*)%S")

	if leading_whitespace == nil then
		return tab
	end
	leading_whitespace = #leading_whitespace

	for i, line in ipairs(tab) do
		tab[i] = line:sub(leading_whitespace + 1)
	end

	return tab
end

-- overwrite existing register with python repl formatting
local function format_reg_to_python(reg)
	local lines = format_to_python(vim.fn.getreg(reg, 1, true))
	local out = table.concat(lines, "\n")

	vim.notify("Formatted register " .. reg .. " for python repl")
	vim.fn.setreg(reg, out)
	return reg
end

-- Sends a table of text to a generic wezterm pane
local function send_to_repl(pane_id, tab)
	-- TODO: Need to format the table such that wezterm cli works properly
	local something = table.concat(tab, "\n")
	os.execute("wezterm cli send-text --pane-id " .. pane_id .. ' "' .. something .. '"')
end

-- AHK implementation: first pass
-- local function send_to_repl()
-- 	local file_loc = conf .. "nvim/ahk_scripts/send_to_repl.ahk"
-- 	os.execute('start "" Autohotkey "' .. file_loc .. '"')
-- end

-- Formats register from getchar to python repl
vim.keymap.set("v", "<leader>y", function()
	local reg

	reg = vim.fn.getchar()
	reg = vim.fn.nr2char(reg)
	vim.cmd('normal! "' .. reg .. "y")
	format_reg_to_python(reg)
end, { noremap = true, silent = true })

-- send visual selection to python replkeymaps
vim.keymap.set("v", "<leader>p", function()
	local lines = visual_selection()
	lines = format_to_python(lines)
	print(lines)
	send_to_repl(1, lines)
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>v", function()
	local reg = vim.fn.getchar()
	reg = vim.fn.nr2char(reg)
	local lines = format_reg_to_python(reg)
	print("Sending register " .. reg .. " to python repl")
	-- TODO: need to systematically get the correct pane
	local pane_id = 2
	send_to_repl(pane_id, lines)
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

vim.keymap.set("n", "<leader><leader>c", ':!pdflatex $(Split-Path -Leaf "%")<CR>')

-- vim: ts=2 sts=2 sw=2 et
