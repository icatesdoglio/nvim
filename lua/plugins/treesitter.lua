return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    opts = function(_, opts)
      opts.ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "latex",
        "query",
        "vim",
        "vimdoc",
        "r",
        "python",
      }

      opts.auto_install = true

      opts.highlight = {
        enable = true,
      }

      opts.incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
        
      }
      opts.textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
          ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
          ["av"] = "@statement.outer",
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]f"] = "@function.outer",
          ["]c"] = "@class.outer",
        },
        goto_previous_start = {
          ["[f"] = "@function.outer",
          ["[c"] = "@class.outer",
          ["[v"] = "@statement.outer",
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ["<leader>a"] = "@parameter.inner",
        },
        swap_previous = {
          ["<leader>A"] = "@parameter.inner",
        },
      },
    }
    
    opts.playground = {
        enable = true,
        disable = {},
        updatetime = 25,
        persist_queries = false,
      }

    opts.indent = {
      enable = true
    }

    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()

    local ts = vim.treesitter
    local ts_utils = require("nvim-treesitter.ts_utils")
    local ts_select = require("nvim-treesitter.textobjects.select")

    local function node_depth(node)
      local depth = 0
      while node:parent() do
        depth = depth + 1
        node = node:parent()
      end
      return depth
    end

    local function goto_next_flat_statement()
      local bufnr = vim.api.nvim_get_current_buf()
      local cursor_node = ts_utils.get_node_at_cursor()
      if not cursor_node then return end

      local target_depth = node_depth(cursor_node)

      local lang = ts.language.get_lang(vim.bo[bufnr].filetype)
      local query = ts.query.get(lang, "textobjects")
      if not query then return end

      local root = ts.get_parser(bufnr, lang):parse()[1]:root()
      local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))
      cursor_row = cursor_row - 1

      for id, node in query:iter_captures(root, bufnr, cursor_row, -1) do
        local name = query.captures[id]
        if name == "statement.outer" then
          -- Skip comment nodes
          if node:type() == "comment" then
            goto continue
          end

          local srow, scol = node:range()
          if (srow > cursor_row) or (srow == cursor_row and scol > cursor_col) then
            if node_depth(node) <= target_depth then
              vim.api.nvim_win_set_cursor(0, { srow + 1, scol })
              return
            end
          end
        end
        ::continue::
      end

      print("No next flat statement found.")
    end

    vim.keymap.set("n", "]v", goto_next_flat_statement, { desc = "Next flat statement (same depth)" })

    local function visual_selection()
      local mode = vim.fn.visualmode()

      local keys = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
      vim.api.nvim_feedkeys(keys, "i", true)

      local _, ls, cs = unpack(vim.fn.getpos("'<")) -- Start position
      local _, le, ce = unpack(vim.fn.getpos("'>")) -- End position

      -- Convert from 1-based to 0-based indexing
      ls, cs = ls - 1, cs - 1
      le, ce = le, ce

      local lines
      if (mode == "V") then
        lines = vim.api.nvim_buf_get_lines(0, ls - 1, le, false)
      else 
        lines = vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le, ce, {})
      end
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

      -- vim.notify("Formatted register " .. reg .. " for python repl")
      vim.fn.setreg(reg, out)
      return reg
    end

    -- Sends a table of text to a generic wezterm pane
    local function send_to_repl(tab)
      local text = table.concat(tab, "\r")
      if vim.env.TERM_PROGRAM == "WezTerm" then
        local handle = io.popen("wezterm cli get-pane-direction right")
        local pane_id = handle:read("*a"):gsub("%s+", "")
        handle:close()
        vim.system({
          "wezterm", "cli", "send-text",
          "--pane-id", pane_id,
          text .. "\r",
          "--no-paste"
        })
      else
        local file_loc = CONF .. "/nvim/ahk_scripts/send_to_repl.ahk"
        vim.fn.setreg("+", text) -- put it in clipboard register
        vim.system {"Autohotkey", file_loc}
      end
    end

    local function select_statement_and_yank(query, reg)
      ts_select.select_textobject(query, "textobjects", "o")
      vim.cmd('normal! "' .. reg .. "y")
    end

    -- Execute control enter send
    vim.keymap.set("n", "<C-h>", function()
      -- setup special register
      local register = "z"

      select_statement_and_yank("@statement.outer", register)

      local lines = format_to_python(vim.fn.getreg(register, 1, true))

      send_to_repl(lines)
      goto_next_flat_statement()
    end)

    vim.keymap.set("v", "<C-h>", function()
      local register = "x"

      vim.cmd('normal! "' .. register .. "y")

      local lines = format_to_python(vim.fn.getreg(register, 1, true))
      local _, le, _ = unpack(vim.fn.getpos("'>"))

      -- move cursor to next line start
      vim.api.nvim_win_set_cursor(0, {le + 1, 0})

      send_to_repl(lines)
    end)
  end 
  },
  {
    "nvim-treesitter/playground",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
  },
}
