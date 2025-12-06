local M = {}

M.map = function(mode, lhs, rhs, args)
  vim.keymap.set(mode, lhs, rhs, args)
end

M.augroup = function(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

M.autocmd = vim.api.nvim_create_autocmd

function M.QuickFixToggle()
  local qf_win_id = vim.fn.getqflist({ winid = 0 }).winid
  if qf_win_id ~= 0 and vim.api.nvim_win_is_valid(qf_win_id) then
    vim.cmd 'cclose'
  else
    vim.cmd 'copen'
  end
end

return M

