return {
	"mbbill/undotree",
	keys = {
		{
			"<leader>u",
		},
	},
	{
		vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle),
	},
}

-- vim: ts=2 sts=2 sw=2 et
