return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  main = "nvim-treesitter.configs",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    {
      "nvim-treesitter/playground",
      cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
    },
  },
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

    -- 💡 Flat statement stepper
    local ts = vim.treesitter
    local ts_utils = require("nvim-treesitter.ts_utils")

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

    -- ⌨️ Bind custom flat-stepper to "]v"
    vim.keymap.set("n", "]v", goto_next_flat_statement, { desc = "Next flat statement (same depth)" })
  end
}
