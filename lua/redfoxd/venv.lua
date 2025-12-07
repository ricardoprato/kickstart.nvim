-- See: https://github.com/linux-cultist/venv-selector.nvim
return {
  'linux-cultist/venv-selector.nvim',
  cmd = 'VenvSelect', -- Lazy load on VenvSelect command
  keys = {
    { '<leader>sv', '<cmd>VenvSelect<CR>', desc = 'Select [V]irtualEnv' },
  },
  ft = 'python', -- Load when opening Python files
  opts = {},
}
