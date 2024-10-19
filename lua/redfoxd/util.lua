local M = {
  {
    { 'nvim-lua/plenary.nvim' },
    -- Neovim plugin that provides the SchemaStore catalog for use with jsonls and yamlls.
    -- https://github.com/b0o/SchemaStore.nvim
    { 'b0o/SchemaStore.nvim', lazy = true, version = false },
    { 'MunifTanjim/nui.nvim' },
  },
}

return M
