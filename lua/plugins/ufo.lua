return {
	"kevinhwang91/nvim-ufo",
  dependencies = "kevinhwang91/promise-async",
  config = function()
    vim.o.foldcolumn = "1"
    vim.o.foldlevel = 99
    vim.o.foldenable = true

    local ufo = require("ufo")

    ufo.setup({
      provider_selector = function(bufnr, filetype, buftype)
        return { "lsp", "indent" }
      end,
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = ("  ↙ %d lines"):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0

        for _, chunk in ipairs(virtText) do
          local chunkText, chunkHl = chunk[1], chunk[2]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if curWidth + chunkWidth < targetWidth then
            table.insert(newVirtText, chunk)
            curWidth = curWidth + chunkWidth
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            table.insert(newVirtText, { chunkText, chunkHl })
            break
          end
        end

        -- Keep the default ellipsis (usually inserted by UFO)
        table.insert(newVirtText, { " …", "FoldLines" })

        -- Add the line count suffix
        table.insert(newVirtText, { suffix, "FoldLines" }) -- Use "Comment" or "Folded" if you prefer
        return newVirtText
      end,
    })
    
    vim.keymap.set("n", "zR", ufo.openAllFolds, { desc = "Open all Folds" })
    vim.keymap.set("n", "zM", ufo.closeAllFolds, { desc = "Close all Folds" })

    vim.api.nvim_set_hl(0, "FoldLines", { fg = "#dd9b23" })  -- Bright orange


  end,
}

-- vim: ts=2 sts=2 sw=2 et
