return {
  'folke/todo-comments.nvim',
  config = function()
    require('todo-comments').setup { signs = false }
    local function map(mode, lhs, rhs, args)
      vim.keymap.set(mode, lhs, rhs, args)
    end

    map('n', '<leader>st', ':TodoTelescope<CR>', { desc = '[S]earch [T]odos' })
  end,
}
