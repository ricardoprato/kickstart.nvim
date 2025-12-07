return {
  'saghen/blink.cmp',
  event = 'InsertEnter',
  dependencies = {
    {
      'L3MON4D3/LuaSnip',
      version = 'v2.*',
      dependencies = {
        {
          'rafamadriz/friendly-snippets',
          dependencies = { 'mstuttgart/vscode-odoo-snippets' },
          config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
          end,
        },
      },
    },
    { 'saghen/blink.compat' },
    {
      'zbirenbaum/copilot.lua', -- for providers='copilot'
      opts = {},
      build = ':Copilot auth',
    },
    {
      'zbirenbaum/copilot-cmp',
      opts = {},
    },
    { 'Kaiser-Yang/blink-cmp-avante' },
  },
  version = '1.*',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = { preset = 'default' },
    snippets = { preset = 'luasnip' },
    sources = {
      -- Remove 'buffer' if you don't want text completions, by default it's only enabled when LSP returns no items
      default = { 'avante', 'lsp', 'path', 'snippets', 'buffer' },
      providers = {
        copilot = {
          name = 'copilot',
          module = 'blink.compat.source',
          enabled = true,
          transform_items = function(ctx, items)
            for _, item in ipairs(items) do
              item.kind_icon = '󰚩'
              item.kind_name = 'Copilot'
            end
            return items
          end,
        },
        avante = {
          module = 'blink-cmp-avante',
          name = 'Avante',
          opts = {
            -- options for blink-cmp-avante
          },
        },
        lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
      },
    },
    fuzzy = { implementation = 'prefer_rust_with_warning' },
    signature = { enabled = true },
    appearance = {
      nerd_font_variant = 'mono',
    },
    completion = { accept = { auto_brackets = { enabled = true } } },
  },
}
