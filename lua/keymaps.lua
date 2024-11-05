-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

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

--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

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

-- DB Settings

vim.api.nvim_create_autocmd("FileType", {
	pattern = "dbout",
	callback = function()
		print("Loaded dbout file!")
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.softtabstop = 4
		vim.opt_local.expandtab = true
		vim.cmd("syntax match dboutBorder '|'")
	end,
})

-- Alter tabs
vim.keymap.set("n", ">", "V><esc>")
vim.keymap.set("n", "<", "V<<esc>")

-- Run python file in new terminal window
-- Grab file location
vim.keymap.set("n", "<leader>py", "", {
	callback = function()
		local file_name = vim.fn.expand("%")
		local bang = "!wt -w 0 python -i " .. file_name
		vim.api.nvim_command(bang)
	end,
	desc = "Run [Py]thon file",
})

-- Cycle through quickfix list
vim.keymap.set("n", "<leader>[", ":cprev<CR>")
vim.keymap.set("n", "<leader>]", ":cnext<CR>")
