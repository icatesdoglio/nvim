local function open_term_in_split(term_number)
	local current_window = vim.api.nvim_get_current_win()
	local current_window_height = vim.api.nvim_win_get_height(current_window)
	local desired_split_height_percentage = 15
	local specified_split_height = math.floor(current_window_height * (1 - (desired_split_height_percentage / 100)))
	local split_command = specified_split_height .. " split"

	vim.api.nvim_command(split_command)

	vim.api.nvim_command("wincmd j")

	require("harpoon"):list("term"):select(term_number)
end

local function get_count_of_windows()
	local windows = vim.api.nvim_list_wins()
	return #windows
end

local function close_all_but_first_window()
	local count_of_windows = get_count_of_windows()

	if count_of_windows == 1 then
		return
	end

	local windows = vim.api.nvim_list_wins()
	for i, window in ipairs(windows) do
		if i ~= 1 then
			vim.api.nvim_win_close(window, false)
		end
	end
end

local function create_standard_layout()
	close_all_but_first_window()

	local count_of_windows = get_count_of_windows()

	if count_of_windows > 1 then
		return
	end

	vim.api.nvim_command("wincmd v")

	open_term_in_split(1)

	vim.api.nvim_command("wincmd l")

	open_term_in_split(2)

	vim.api.nvim_command("1wincmd w")
end

local function term_select(list_item, list, options)
	local Extensions = require("harpoon.extensions")
	local Logger = require("harpoon.logger")

	Logger:log("term_config#select", list_item, list.name, options)

	options = options or {}

	-- custom bit --
	-- Open terminal if list item is nil, then add buffer to terminal harpoon list.
	if list_item == nil then
		vim.cmd("terminal")

		require("harpoon"):list("term"):append()

		return
	end

	local bufnr = vim.fn.bufnr(list_item.value)
	local set_position = false

	if bufnr == -1 then
		set_position = true
		bufnr = vim.fn.bufnr(list_item.value, true)
	end

	if not vim.api.nvim_buf_is_loaded(bufnr) then
		vim.fn.bufload(bufnr)
		vim.api.nvim_set_option_value("buflisted", true, {
			buf = bufnr,
		})
	end

	if options.vsplit then
		vim.cmd("vsplit")
	elseif options.split then
		vim.cmd("split")
	elseif options.tabedit then
		vim.cmd("tabedit")
	end

	vim.api.nvim_set_current_buf(bufnr)

	if set_position then
		vim.api.nvim_win_set_cursor(0, {
			list_item.context.row or 1,
			list_item.context.col or 0,
		})
	end

	Extensions.extensions:emit(Extensions.event_names.NAVIGATE, {
		buffer = bufnr,
	})
end

return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	opts = {
		term = {
			select_with_nil = true,
			encode = false,
			select = term_select,
		},
	},
	keys = {
		{
			"<leader>ps",
			function()
				create_standard_layout()
			end,
			desc = "Creates multiple splits to create my 'standard layout' for programming",
		},
		{
			"<leader>th",
			function()
				local harpoon = require("harpoon")
				harpoon.ui:toggle_quick_menu(harpoon:list("term"))
			end,
			desc = "opens harpoon's list of terminal buffers",
		},
		{
			"<leader>t1",
			function()
				require("harpoon"):list("term"):select(1)
			end,
			desc = "selects first buffer in harpoon term list",
		},
		{
			"<leader>t2",
			function()
				require("harpoon"):list("term"):select(2)
			end,
			desc = "selects second buffer in harpoon term list",
		},
		{
			"<leader>t3",
			function()
				require("harpoon"):list("term"):select(3)
			end,
			desc = "selects third buffer in harpoon term list",
		},
		{
			"<leader>t4",
			function()
				require("harpoon"):list("term"):select(4)
			end,
			desc = "selects fourth buffer in harpoon term list",
		},
		{
			"<leader>t5",
			function()
				require("harpoon"):list("term"):select(5)
			end,
			desc = "selects fifth buffer in harpoon term list",
		},
		{
			"<leader>t6",
			function()
				require("harpoon"):list("term"):select(6)
			end,
			desc = "selects sixth buffer in harpoon term list",
		},
		{
			"<leader>t7",
			function()
				require("harpoon"):list("term"):select(7)
			end,
			desc = "selects seventh buffer in harpoon term list",
		},
		{
			"<leader>t8",
			function()
				require("harpoon"):list("term"):select(8)
			end,
			desc = "selects eighth buffer in harpoon term list",
		},
		{
			"<leader>t9",
			function()
				require("harpoon"):list("term"):select(9)
			end,
			desc = "selects ninth buffer in harpoon term list",
		},
		{
			"<leader>pt1",
			function()
				open_term_in_split(1)
			end,
			desc = "split window and open first terminal buffer",
		},
		{
			"<leader>pt2",
			function()
				open_term_in_split(2)
			end,
			desc = "split window and open second terminal buffer",
		},
		{
			"<leader>pt3",
			function()
				open_term_in_split(3)
			end,
			desc = "split window and open third terminal buffer",
		},
		{
			"<leader>pt4",
			function()
				open_term_in_split(4)
			end,
			desc = "split window and open fourth terminal buffer",
		},
		{
			"<leader>pt5",
			function()
				open_term_in_split(5)
			end,
			desc = "split window and open fifth terminal buffer",
		},
		{
			"<leader>pt6",
			function()
				open_term_in_split(6)
			end,
			desc = "split window and open sixth terminal buffer",
		},
		{
			"<leader>pt7",
			function()
				open_term_in_split(7)
			end,
			desc = "split window and open seventh terminal buffer",
		},
		{
			"<leader>pt8",
			function()
				open_term_in_split(8)
			end,
			desc = "split window and open eighth terminal buffer",
		},
		{
			"<leader>pt9",
			function()
				open_term_in_split(9)
			end,
			desc = "split window and open ninth terminal buffer",
		},
	},
}
