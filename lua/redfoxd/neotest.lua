return {
  'nvim-neotest/neotest',
  cmd = { 'Neotest' },
  keys = {
    { "<leader>t", group = "test" },
    { "<leader>tt", function() require("neotest").run.run() end, desc = "Run tests" },
    { "<leader>tT", function() require("neotest").run.stop() end, desc = "Stop tests" },
    { "<leader>ta", function() require("neotest").run.attach() end, desc = "Attach to tests" },
    { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Test summary" },
  },
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-neotest/neotest-python',
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-python' {
          dap = { justMyCode = false },
          args = { '--disable-pytest-warnings', '' },
        },
      },
    }
  end,
}