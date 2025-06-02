local M = {}
local ns = vim.api.nvim_create_namespace("custom_foldtext")

function M.custom_foldtext()
  local start_line = vim.fn.getline(vim.v.foldstart)
  local end_line = vim.fn.getline(vim.v.foldend):gsub("^%s+", "")
  local lines = vim.v.foldend - vim.v.foldstart + 1
  return string.format("%s <-> %s ↙ %d lines", start_line, end_line, lines)
end

return M

-- lua(require("custom.foldtext").custom_foldtext()
