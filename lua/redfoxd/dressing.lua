-- lua/redfoxd/dressing.lua
-- Dressing is a plugin to provide a prettier UI for vim.ui.select and vim.ui.input.
-- https://github.com/stevearc/dressing.nvim
return {
  'stevearc/dressing.nvim',
  event = 'VeryLazy',
  opts = {
    -- Options for `vim.ui.select`
    select = {
      -- Use Telescope for selections by default
      backend = 'telescope',
      -- Set to `false` to disable the Telescope theme and use the default
      -- dropdown.
      telescope = require('telescope.themes').get_dropdown {
        initial_mode = 'insert',
      },
    },
    -- Options for `vim.ui.input`
    input = {
      -- Use a Neovim floating window for input by default
      backend = 'popup',
    },
  },
}
