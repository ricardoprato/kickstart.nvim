return -- Lua
{
  'folke/zen-mode.nvim',
  dependencies = {
    { 'folke/twilight.nvim' },
  },
  opts = {},
  keys = {
    { '<leader>z', ':ZenMode<CR>', { desc = 'ZenMode' } },
  },
}
