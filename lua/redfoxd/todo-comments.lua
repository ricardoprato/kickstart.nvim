return {
  'folke/todo-comments.nvim',
  cmd = 'TodoTelescope',
  keys = {
    { '<leader>st', '<cmd>TodoTelescope<cr>', desc = '[S]earch [T]odos' },
  },
  config = function()
    require('todo-comments').setup { signs = false }
  end,
}
