local M = {}

M.map = function(mode, lhs, rhs, args)
  vim.keymap.set(mode, lhs, rhs, args)
end

M.augroup = function(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

M.autocmd = vim.api.nvim_create_autocmd

return M
