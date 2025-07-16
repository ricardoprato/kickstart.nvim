return {
  { -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'catppuccin/nvim',
    lazy = false,
    priority = 1000, -- Make sure to load this before all the other start plugins.
    name = 'catppuccin',
    init = function()
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    -- init = function()
    --   vim.cmd.colorscheme 'rose-pine'
    -- end,
  },
  {
    'rebelot/kanagawa.nvim',
    name = 'kanagawa',
    --   init = function()
    --     vim.cmd.colorscheme 'kanagawa'
    --   end,
  },
  { -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    -- lazy = false,
    -- priority = 1000, -- Make sure to load this before all the other start plugins.
    -- name = 'tokyonight',
    -- init = function()
    --   vim.cmd.colorscheme 'tokyonight-night'
    -- end,
  },
}
