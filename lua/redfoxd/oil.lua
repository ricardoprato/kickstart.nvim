return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil
    ---@type oil.SetupOpts
    opts = {},
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- use if you prefer nvim-web-devicons
    lazy = false,
    keys = {
      { '-', '<CMD>Oil<CR>', desc = 'Open parent directory' },
      { '<space>-', '<CMD>Oil<CR>', desc = 'Open parent directory' },
    },
    config = function()
      require('oil').setup {
        columns = { 'icon' },
        keymaps = {
          ['C-h'] = false,
          ['M-h'] = 'actions.select_split',
        },
        view_options = {
          show_hidden = true,
        },
      }
      vim.keymap.set('n', '-', function()
        require('oil').toggle_float()
      end, { desc = 'Open parent directory' })
    end,
  },
}
