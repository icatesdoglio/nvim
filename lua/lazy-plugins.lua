-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require("lazy").setup({
	-- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
	require("plugins.theme"),
	require("plugins.basic"),
	require("plugins.telescope"),
	require("plugins.whichkey"),
	require("plugins.lazydev"),
	require("plugins.lspconfig"),
	require("plugins.autocomplete"),
	require("plugins.autoformat"),
	require("plugins.harpoon"),
	require("plugins.undotree"),
	require("plugins.treesitter"),
	require("plugins.harpoon_term"),
}, {
	ui = {
		-- If you are using a Nerd Font: set icons to an empty table which will use the
		-- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
		icons = vim.g.have_nerd_font and {},
	},
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
