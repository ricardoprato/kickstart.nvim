-- autopairs
-- https://github.com/windwp/nvim-autopairs

return {
  'windwp/nvim-autopairs',
  ft = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'html',
    'xml',
  },
  -- Optional dependency
  dependencies = { 'hrsh7th/nvim-cmp' },
  opts = {}
}
