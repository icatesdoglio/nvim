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

-- Cycle through quickfix list
vim.keymap.set("n", "<leader>[", ":cprev<CR>")
vim.keymap.set("n", "<leader>]", ":cnext<CR>")

-- Re-source file
vim.keymap.set("n", "<leader><leader>r", function()
  local current_file = vim.fn.expand("%:p")
  local file_loc
  if vim.bo.filetype == "r" then
    file_loc = CONF .. "/nvim/ahk_scripts/resource_R.ahk"
    print(file_loc)
  elseif vim.bo.filetype == "python" then
    file_loc = CONF .. "/nvim/ahk_scripts/resource_python.ahk"
  else
    error("Unknown filetype: " .. vim.bo.filetype)
  end
  vim.system({ "Autohotkey", file_loc, current_file })
end, {desc = "[R]e-source current file"})

-- Just source r files
vim.keymap.set("n", "<leader><leader>s", function()
  local current_file = vim.fn.expand("%:p")
  local file_loc
  if vim.bo.filetype == "r" then
    file_loc = CONF .. "/ahk_scripts/source_R.ahk"
  else
    error("Unknown filetype: " .. vim.bo.filetype)
  end
  vim.system({ "Autohotkey", file_loc, current_file })
end, {desc = "[R]e-source current file"})

-- Re-source snippets
vim.keymap.set("n", "<leader><leader>x", function()
	require("luasnip").cleanup()
	dofile(vim.fn.stdpath("config") .. "/lua/plugins/custom_snippets.lua")
	print("Snippets reloaded!")
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader><leader>l", ':!pdflatex $(Split-Path -Leaf "%")<CR>')

vim.keymap.set("v", "<leader>r", function()
  local code = table.concat(vim.fn.getline("'<", "'>"), "\n")
  loadstring(code)()
end, { desc = "Run selected Lua code" })

-- vim: ts=2 sts=2 sw=2 et
