return {
  'NeogitOrg/neogit',
  dependencies = {
    'sindrets/diffview.nvim', -- optional - Diff integration
  },
  keys = {
    { '<leader>gg', ':Neogit<CR>', desc = 'Neogit' },
  },
  config = true,
}
