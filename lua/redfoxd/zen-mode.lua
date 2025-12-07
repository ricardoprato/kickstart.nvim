return -- Lua
{
  'folke/zen-mode.nvim',
  dependencies = {
    { 'folke/twilight.nvim' },
  },
  opts = {},
  keys = {
    { '<leader>uz', ':ZenMode<CR>', { desc = 'Toggle ZenMode' } },
  },
}
