return {
  {
    'stevearc/oil.nvim',
    cmd = 'Oil',
    ---@module 'oil
    ---@type oil.SetupOpts
    opts = {},
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- use if you prefer nvim-web-devicons
    keys = {
      {
        '-',
        function()
          require('oil').toggle_float()
        end,
        desc = 'Open parent directory',
      },
      { '<space>-', '<CMD>Oil<CR>', desc = 'Open parent directory' },
    },
    opts = {
      columns = { 'icon' },
      keymaps = {
        ['C-h'] = false,
        ['M-h'] = 'actions.select_split',
      },
      view_options = {
        show_hidden = true,
      },
    },
  },
}

