return { -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- Useful status updates for LSP.
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    { 'j-hui/fidget.nvim', opts = {} },

    --  Plugin that properly configures LuaLS for editing your Neovim config by lazily updating your workspace libraries.
    --  https://github.com/folke/lazydev.nvim
    { 'folke/lazydev.nvim', opts = {} },
    -- Neovim plugin to manage global and project-local settings
    -- https://github.com/folke/neoconf.nvim
    {
      'folke/neoconf.nvim',
      cmd = 'Neoconf',
      opts = {},
    },
  },
  config = function()
    local lspconfigs = require 'lspconfig.configs'
    lspconfigs.odoo_lsp = {
      default_config = {
        name = 'odoo-lsp',
        cmd = { 'odoo-lsp' },
        filetypes = { 'javascript', 'xml', 'python' },
        root_dir = require('lspconfig.util').root_pattern('.odoo_lsp', '.odoo_lsp.json', '.git'),
      },
    }
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        -- NOTE: Remember that Lua is a real programming language, and as such it is possible
        -- to define small helper and utility functions so you don't have to repeat yourself.
        --
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-t>.

        if client and client.server_capabilities.definitionProvider then
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        end

        -- Find references for the word under your cursor.
        if client and client.server_capabilities.referencesProvider then
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        end

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        if client and client.server_capabilities.implementationProvider then
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        end

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        if client and client.server_capabilities.typeDefinitionProvider then
          map('<leader>lD', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        end

        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        if client and client.server_capabilities.workspaceSymbolProvider then
          map('<leader>ld', require('telescope.builtin').lsp_document_symbols, '[D]ocument Symbols')
        end

        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        if client and client.server_capabilities.workspaceSymbolProvider then
          map('<leader>lw', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace Symbols')
        end

        -- Rename the variable under your cursor.
        --  Most Language Servers support renaming across files, etc.
        if client and client.server_capabilities.renameProvider then
          map('<leader>lr', vim.lsp.buf.rename, '[R]ename')
        end

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        if client and client.server_capabilities.codeActionProvider then
          map('<leader>lc', vim.lsp.buf.code_action, '[C]ode Action')
        end

        -- Opens a popup that displays documentation about the word under your cursor
        --  See `:help K` for why this keymap.
        if client and client.server_capabilities.hoverProvider then
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
        end

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header.
        if client and client.server_capabilities.declarationProvider then
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        end

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        if client and client.server_capabilities.documentHighlightProvider then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        -- The following autocommand is used to enable inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP specification.
    --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
    --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- Enable the following language servers
    --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
    --
    --  Add any additional override configuration in the following tables. Available keys are:
    --  - cmd (table): Override the default command used to start the server
    --  - filetypes (table): Override the default list of associated filetypes for the server
    --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
    --  - settings (table): Override the default settings passed when initializing the server.
    --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
    local lspconfig = require 'lspconfig'
    lspconfig.odoo_lsp.setup {}
    local servers = {
      -- clangd = {},
      -- gopls = {},
      -- rust_analyzer = {},
      -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
      --
      -- Some languages (like typescript) have entire language plugins that can be useful:
      --    https://github.com/pmizio/typescript-tools.nvim
      --
      -- But for many setups, the LSP (`tsserver`) will work just fine
      --
      jsonls = {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      },
      yamlls = {
        settings = {
          yaml = {
            schemaStore = {
              -- You must disable built-in schemaStore support if you want to use
              -- this plugin and its advanced options like `ignore`.
              enable = false,
              -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
              url = '',
            },
            schemas = require('schemastore').yaml.schemas(),
          },
        },
      },
      lua_ls = {
        -- cmd = {...},
        -- filetypes = { ...},
        -- capabilities = {},
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },
    }

    -- Ensure the servers and tools above are installed
    --  To check the current status of installed tools and/or manually install
    --  other tools, you can run
    --    :Mason
    --
    --  You can press `g?` for help in this menu.
    require('mason').setup()

    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua', -- Used to format Lua code
    })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }
    require('mason-lspconfig').setup()
    require('mason-lspconfig').setup_handlers {
      function(server_name)
        local server = servers[server_name] or {}
        -- This handles overriding only values explicitly passed
        -- by the server configuration above. Useful when disabling
        -- certain features of an LSP (for example, turning off formatting for tsserver)
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        require('lspconfig')[server_name].setup(server)
      end,
    }
  end,
}
