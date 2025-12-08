local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end
local autocmd = vim.api.nvim_create_autocmd
-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = augroup 'kickstart-highlight-yank',
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Check if we need to reload the file when it changed
autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = augroup 'checktime',
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd 'checktime'
    end
  end,
})

autocmd('BufWinEnter', {
  desc = 'Make q close help, man, quickfix, dap floats',
  group = augroup 'q_close_windows',
  callback = function(args)
    local buftype = vim.api.nvim_get_option_value('buftype', { buf = args.buf })
    if vim.tbl_contains({ 'help', 'nofile', 'quickfix' }, buftype) and vim.fn.maparg('q', 'n') == '' then
      vim.keymap.set('n', 'q', '<cmd>close<cr>', {
        desc = 'Close window',
        buffer = args.buf,
        silent = true,
        nowait = true,
      })
    end
  end,
})

-- Autosave on FocusLost or BufModifiedSet
-- Initialize buffer-local autosave setting
autocmd({ 'BufNewFile', 'BufReadPost' }, {
  group = augroup 'autosave_init',
  callback = function()
    vim.b.disable_autosave = vim.g.disable_autosave
  end,
})

autocmd({ 'BufModifiedSet', 'FocusLost' }, {
  group = augroup 'autosave',
  callback = function()
    if not vim.b.disable_autosave and vim.bo.buftype == '' and vim.bo.modifiable and vim.bo.modified then
      vim.cmd.write()
    end
  end,
})

-- Initialize buffer-local autoformat setting
autocmd({ 'BufNewFile', 'BufReadPost' }, {
  group = augroup 'autoformat_init',
  callback = function()
    vim.b.disable_autoformat = vim.g.disable_autoformat
  end,
})

