vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.mouse = "a"
vim.opt.showmode = false

--  Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

-- Enable break indent
vim.opt.breakindent = true

vim.opt.undofile = true

-- Search Options
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.inccommand = "split"
vim.opt.splitright = true

-- Minscreen lines at edges
vim.opt.scrolloff = 10
vim.opt.colorcolumn = "80"

vim.g.undotree_DiffCommand = "FC"

vim.g.terminal_emulator = "powershell"

-- Shell Emulator Not sure I want this
vim.opt.shell = "powershell"

vim.o.shellcmdflag =
	"-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"

vim.o.shellredir = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"

vim.o.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"

vim.o.shellquote = ""

-- vim: ts=2 sts=2 sw=2 et
