return { -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>cf',
      function()
        require('conform').format({ async = true, lsp_format = 'fallback' }, function(err)
          if not err then
            local mode = vim.api.nvim_get_mode().mode
            if vim.startswith(string.lower(mode), 'v') then
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
            end
          end
        end)
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  -- This will provide type hinting with LuaLS
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] or vim.b.disable_autoformat then
        return
      end
      return {
        timeout_ms = 2000,
        lsp_format = 'fallback',
      }
    end,
    formatters = {
      black = {
        prepend_args = { '--fast' },
      },
    },
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'isort', 'black' },
      javascript = { 'prettierd', 'prettier', 'deno_fmt', stop_after_first = true },
      typescript = { 'prettierd', 'prettier', 'deno_fmt', stop_after_first = true },
      astro = { 'deno_fmt', 'prettierd', 'prettier', stop_after_first = true },
      svelte = { 'prettierd', 'prettier', 'deno_fmt', stop_after_first = true },
      json = { 'prettierd', 'prettier', 'deno_fmt', stop_after_first = true },
    },
  },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
