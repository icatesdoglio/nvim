return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
      -- install_dir must be set explicitly, even to the default value: only then
      -- does nvim-treesitter prepend it to 'runtimepath', which is what lets
      -- vim.treesitter.query.get() find the parsers' linked query files
      -- (highlights/indents/etc). Without this, indent/highlight queries silently
      -- fail to resolve for every language.
      require("nvim-treesitter").setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      local ensure_installed = {
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

      require("nvim-treesitter").install(ensure_installed):wait(300000)

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          if pcall(vim.treesitter.start) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    init = function()
      -- Disable built-in ftplugin mappings to avoid conflicts with our own.
      vim.g.no_plugin_maps = true
    end,
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true,
          selection_modes = {
            ["@parameter.outer"] = "v",
            ["@function.outer"] = "V",
            ["@class.outer"] = "V",
            ["@statement.outer"] = "V",
          },
        },
        move = {
          set_jumps = true,
        },
      })

      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")
      local swap = require("nvim-treesitter-textobjects.swap")

      local function select_textobject(query, group)
        return function()
          select.select_textobject(query, group or "textobjects")
        end
      end

      vim.keymap.set({ "x", "o" }, "af", select_textobject("@function.outer"))
      vim.keymap.set({ "x", "o" }, "if", select_textobject("@function.inner"))
      vim.keymap.set({ "x", "o" }, "ac", select_textobject("@class.outer"))
      vim.keymap.set({ "x", "o" }, "ic", select_textobject("@class.inner"))
      vim.keymap.set({ "x", "o" }, "aa", select_textobject("@parameter.outer"))
      vim.keymap.set({ "x", "o" }, "ia", select_textobject("@parameter.inner"))
      vim.keymap.set({ "x", "o" }, "av", select_textobject("@statement.outer"))
      vim.keymap.set({ "x", "o" }, "as", select_textobject("@local.scope", "locals"))

      vim.keymap.set({ "n", "x", "o" }, "]f", function()
        move.goto_next_start("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "]c", function()
        move.goto_next_start("@class.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[f", function()
        move.goto_previous_start("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[c", function()
        move.goto_previous_start("@class.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[v", function()
        move.goto_previous_start("@statement.outer", "textobjects")
      end)

      vim.keymap.set("n", "<leader>a", function()
        swap.swap_next("@parameter.inner")
      end)
      vim.keymap.set("n", "<leader>A", function()
        swap.swap_previous("@parameter.inner")
      end)

      local ts = vim.treesitter

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
        local cursor_node = ts.get_node()
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
          -- Signal the persistent ctrl_enter_hotkey.ahk process via a trigger
          -- file instead of spawning a new AutoHotkey process per call:
          -- running a second AutoHotkey process was found to disrupt that
          -- script's keyboard hook, silently dropping later Ctrl+Enter
          -- presses.
          local trigger_path = (os.getenv("TEMP") or os.getenv("TMP")) .. "/nvim_repl_trigger.tmp"
          vim.fn.setreg("+", text) -- put it in clipboard register
          vim.fn.writefile({ tostring(vim.uv.hrtime()) }, trigger_path)
        end
      end

      local function select_statement_and_yank(query, reg)
        select.select_textobject(query, "textobjects")
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

        -- move cursor to next line start, clamped to end of file
        local last_line = vim.api.nvim_buf_line_count(0)
        vim.api.nvim_win_set_cursor(0, {math.min(le + 1, last_line), 0})

        send_to_repl(lines)
      end)
    end
  },
}
