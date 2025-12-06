return { -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  event = 'VeryLazy',
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    -- Mason must be loaded before its dependents so we need to set it up here.
    -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
    { 'mason-org/mason.nvim', cmd = 'Mason' },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- SchemaStore for jsonls and yamlls
    { 'b0o/SchemaStore.nvim', version = false },

    -- Useful status updates for LSP.
    { 'j-hui/fidget.nvim', event = 'VeryLazy', opts = {} },
    {
      -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      'folke/lazydev.nvim',
      ft = 'lua',
      opts = {
        library = {
          -- Load luvit types when the `vim.uv` word is found
          { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        },
      },
    },
    -- Neovim plugin to manage global and project-local settings
    -- https://github.com/folke/neoconf.nvim
    {
      'folke/neoconf.nvim',
      cmd = 'Neoconf',
      opts = {},
    },
    { 'saghen/blink.cmp' },
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        -- NOTE: Remember that Lua is a real programming language, and as such it is possible
        -- to define small helper and utility functions so you don't have to repeat yourself.
        --
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-t>.

        if client and client.server_capabilities.definitionProvider then
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        end

        -- Find references for the word under your cursor.
        if client and client.server_capabilities.referencesProvider then
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        end

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        if client and client.server_capabilities.implementationProvider then
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        end

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        if client and client.server_capabilities.typeDefinitionProvider then
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
        end

        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        if client and client.server_capabilities.workspaceSymbolProvider then
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
        end

        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        if client and client.server_capabilities.workspaceSymbolProvider then
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
        end

        -- Rename the variable under your cursor.
        --  Most Language Servers support renaming across files, etc.
        if client and client.server_capabilities.renameProvider then
          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
        end

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        if client and client.server_capabilities.codeActionProvider then
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
        end

        -- Opens a popup that displays documentation about the word under your cursor
        --  See `:help K` for why this keymap.
        if client and client.server_capabilities.hoverProvider then
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
        end

        if client and client.server_capabilities.signatureHelpProvider then
          map('K', vim.lsp.buf.signature_help, 'Signature Documentation', 'i')
        end

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header.
        if client and client.server_capabilities.declarationProvider then
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        end

        if client and client.server_capabilities.callHierarchyProvider then
          map('g<', require('telescope.builtin').lsp_incoming_calls, 'Goto Incoming Calls')
          map('g>', require('telescope.builtin').lsp_outgoing_calls, 'Goto Outgoing Calls')
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
          map('<leader>uh', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, 'Toggle Inlay [H]ints')
        end
      end,
    })

    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP specification.
    --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
    --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
    --
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities({}, false))
    -- Ensure the servers and tools above are installed
    --  To check the current status of installed tools and/or manually install
    --  other tools, you can run
    --    :Mason
    --
    --  You can press `g?` for help in this menu.
    require('mason').setup()
    local lsp_files = vim.fn.glob('lsp/*', true, true)
    local servers = {}
    for _, file in ipairs(lsp_files) do
      local server_name = vim.fn.fnamemodify(file, ':t:r')
      if server_name ~= 'odoo_lsp' then
        table.insert(servers, server_name)
      end
    end
    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    vim.list_extend(servers, {
      'stylua', -- Used to format Lua code
    })
    require('mason-tool-installer').setup { ensure_installed = servers }
    require('mason-lspconfig').setup {
      ensure_installed = {},
      automatic_enable = true,
      handlers = {
        denols = function()
          vim.lsp.config.denols.setup {
            root_dir = function(fname)
              return vim.lsp.util.root_pattern('deno.json', 'deno.jsonc')(fname)
            end,
            init_options = {
              lint = true,
              unstable = true,
              suggest = {
                imports = {
                  hosts = {
                    ['https://deno.land'] = true,
                    ['https://cdn.nest.land'] = true,
                    ['https://crux.land'] = true,
                  },
                },
              },
            },
            capabilities = capabilities,
          }
        end,
        tsserver = function()
          vim.lsp.config.tsserver.setup {
            root_dir = function(fname)
              local is_deno_project = vim.lsp.util.root_pattern('deno.json', 'deno.jsonc')(fname)
              if is_deno_project then
                return nil
              end
              return vim.lsp.util.root_pattern('package.json', 'tsconfig.json', 'jsconfig.json', '.git')(fname) or vim.lsp.util.find_git_ancestor(fname)
            end,
            capabilities = capabilities,
          }
        end,
        -- For any server not explicitly handled, use the default setup function
        ['*'] = function(server_name)
          vim.lsp.config[server_name].setup {
            capabilities = capabilities,
          }
        end,
      },
    }

    vim.lsp.config('*', {
      capabilities = capabilities,
    })
    vim.lsp.enable 'odoo_lsp'
  end,
}
