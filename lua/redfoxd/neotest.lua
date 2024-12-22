return {
  'nvim-neotest/neotest',
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

-- "--disable-pytest-warnings",
--        "--cov=odoo_customization_pyxis/ddhh_absences_automatic",
--        "--odoo-database=PYXIS"
