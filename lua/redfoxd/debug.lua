-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    { 'rcarriga/nvim-dap-ui' },
    { 'nvim-neotest/nvim-nio' },
    { 'williamboman/mason.nvim' },
    { 'jay-babu/mason-nvim-dap.nvim' },
    { 'theHamsta/nvim-dap-virtual-text', opts = {} },
    { 'mfussenegger/nvim-dap-python' },
    {
      'mxsdev/nvim-dap-vscode-js',
      ft = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
      dependencies = { 'mfussenegger/nvim-dap' },
    },
  },
  config = function()
    local dap = require 'dap'
    local widgets = require 'dap.ui.widgets'
    local dapui = require 'dapui'
    local map = require('utils').map

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        'debugpy', -- For Python (Odoo)
        'js-debug-adapter', -- For Node.js and Deno
      },
    }
    map('v', '<F2>', dapui.eval, { desc = 'Debug: Evaluate Input' })
    map('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
    map('n', '<S-F5>', dap.terminate, { desc = 'Debug: Stop' })
    map('n', '<C-F5>', dap.restart_frame, { desc = 'Debug: Restart' })
    map('n', '<F6>', dap.pause, { desc = 'Debug: Pause' })
    map('n', '<F9>', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    map('n', '<S-F9>', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })
    map('n', '<F10>', dap.step_over, { desc = 'Debug: Step Over' })
    map('n', '<F11>', dap.step_into, { desc = 'Debug: Step Into' })
    map('n', '<S-F11>', dap.step_out, { desc = 'Debug: Step Out' })
    map('n', '<leader>du', dapui.toggle, { desc = 'Debug: Toggle Debug UI' })
    map('n', '<leader>dh', widgets.hover, { desc = 'Debug: Toggle Debug UI' })
    map('v', '<leader>de', dapui.eval, { desc = 'Debug: Evaluate Input (F2)' })
    map('n', '<leader>da', dap.set_exception_breakpoints, { desc = 'Debug: Set Exception Breakpoints' })
    map('n', '<leader>dc', dap.continue, { desc = 'Debug: Start/Continue (F5)' })
    map('n', '<leader>dQ', dap.terminate, { desc = 'Debug: Stop (S-F5)' })
    map('n', '<leader>dr', dap.restart, { desc = 'Debug: Restart (C-F5)' })
    map('n', '<leader>dp', dap.pause, { desc = 'Debug: Pause (F6)' })
    map('n', '<leader>dR', dap.repl.toggle, { desc = 'Debug: Toggle REPL' })
    map('n', '<leader>ds', dap.run_to_cursor, { desc = 'Debug: Run to Cursor' })
    map('n', '<leader>dB', dap.clear_breakpoints, { desc = 'Debug: Clear Breakpoints' })
    map('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint (F9)' })
    map('n', '<leader>dC', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint S-F9' })
    map('n', '<leader>do', dap.step_over, { desc = 'Debug: Step Over F10' })
    map('n', '<leader>di', dap.step_into, { desc = 'Debug: Step Into F11' })
    map('n', '<leader>dO', dap.step_out, { desc = 'Debug: Step Out S-F11' })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      element_mappings = {},
      expand_lines = true,
      floating = {
        border = 'single',
        mappings = {
          close = { 'q', '<Esc>' },
        },
      },
      force_buffers = true,
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        element = 'repl',
        enabled = true,
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
      layouts = {
        {
          elements = {
            {
              id = 'scopes',
              size = 0.25,
            },
            {
              id = 'breakpoints',
              size = 0.25,
            },
            {
              id = 'stacks',
              size = 0.25,
            },
            {
              id = 'watches',
              size = 0.25,
            },
          },
          position = 'right',
          size = 30,
        },
        {
          elements = { {
            id = 'repl',
            size = 0.5,
          }, {
            id = 'console',
            size = 0.5,
          } },
          position = 'bottom',
          size = 8,
        },
      },
      mappings = {
        edit = 'e',
        expand = { '<CR>', '<2-LeftMouse>' },
        open = 'o',
        remove = 'd',
        repl = 'r',
        toggle = 't',
      },
      render = {
        indent = 1,
        max_value_lines = 100,
      },
    }

    -- Setup js-debug-adapter for Node.js and Deno
    require('dap-vscode-js').setup({
      node_path = 'node', -- Path to node executable.
      -- debugger_path = "(runtimedir)/lib/node_modules/vscode-js-debug", -- Path to vscode-js-debug installation.
      -- works in windows and linux
      debugger_path = (function()
        local mason_path = vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter/extension/out/src'
        if vim.fn.isdirectory(mason_path) then
          return mason_path
        end
        return nil
      end)(),
      adapters = { 'pwa-node', 'pwa-deno', 'pwa-msedge', 'pwa-chrome' }, -- which adapters to register
      log_file = vim.fn.stdpath('cache') .. '/dap_vscode_js.log',
      log_level = 'OFF', --
      -- If you want to use this with an existing `package.json`
      -- it's suggested to use the `dap-vscode-js` command to create a `launch.json`
      -- then convert it to a lua configuration.
    })

    -- DAP configurations for Node.js
    -- ... existing code ...

    local function is_deno_project()
      local current_file = vim.api.nvim_buf_get_name(0)
      if current_file == "" then return false end
      local current_dir = vim.fn.fnamemodify(current_file, ':h')
      local util = require('lspconfig.util') -- Re-use util from lspconfig for root_pattern
      return util.root_pattern('deno.json', 'deno.jsonc')(current_dir) ~= nil
    end

    -- DAP configurations for Node.js and Deno (unified)
    -- We will redefine typescript and javascript configurations to be dynamic
    dap.configurations.javascript = {
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch file (Node.js)',
        program = '${file}',
        cwd = '${workspaceFolder}',
        console = 'integratedTerminal',
        condition = function() return not is_deno_project() end,
      },
      {
        type = 'pwa-deno',
        request = 'launch',
        name = 'Launch Deno file',
        program = '${file}',
        cwd = '${workspaceFolder}',
        console = 'integratedTerminal',
        runtimeExecutable = 'deno',
        runtimeArgs = { 'run', '--inspect', '--allow-all' },
        condition = is_deno_project,
      },
      -- Attach to process for Node.js
      {
        type = 'pwa-node',
        request = 'attach',
        name = 'Attach to process (Node.js)',
        processId = require('dap.utils').pick_process,
        cwd = '${workspaceFolder}',
        console = 'integratedTerminal',
        condition = function() return not is_deno_project() end,
      },
      -- Launch with nodemon for Node.js
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch with nodemon (Node.js)',
        program = '${file}',
        runtimeExecutable = 'nodemon',
        args = {
          '--nolazy',
          '--inspect-brk=9229',
          '--exec',
          'node',
          '${file}',
        },
        console = 'integratedTerminal',
        cwd = '${workspaceFolder}',
        protocol = 'inspector',
        sourceMaps = true,
        trace = true,
        port = 9229,
        skipFiles = { '<node_internals>/**', 'node_modules/**' },
        condition = function() return not is_deno_project() end,
      },
    }
    -- Alias typescript configs to javascript, they will also use the condition
    dap.configurations.typescript = dap.configurations.javascript
    dap.configurations.typescriptreact = dap.configurations.javascript
    dap.configurations.javascriptreact = dap.configurations.javascript

    -- Remove the explicit `dap.configurations.deno` as it's now handled by `javascript` and `typescript` with conditions
    -- dap.configurations.deno = { ... } -- THIS BLOCK WILL BE REMOVED

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close
    vim.fn.sign_define('DapBreakpoint', {
      text = '',
      texthl = 'DiagnosticSignError',
      linehl = '',
      numhl = '',
    })
    vim.fn.sign_define('DapBreakpointRejected', {
      text = '',
      texthl = 'DiagnosticSignError',
      linehl = '',
      numhl = '',
    })
    vim.fn.sign_define('DapStopped', {
      text = '',
      texthl = 'DiagnosticSignWarn',
      linehl = 'Visual',
      numhl = 'DiagnosticSignWarn',
    })

    local path = vim.fn.exepath 'debugpy'
    require('dap-python').setup(path .. '/venv/bin/python')
    local autocmd = require('utils').autocmd
    local augroup = require('utils').augroup
    autocmd({ 'VimEnter', 'FileType', 'BufEnter', 'WinEnter' }, {
      desc = 'Automatically load the launch.json configuration for the DAP (Debug Adapter Protocol) on startup',
      group = augroup 'startup_command',
      callback = function()
        local status, plugin = pcall(require, 'dap.ext.vscode')
        if status then
          plugin.load_launchjs()
        end
      end,
    })
  end,
}