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
  keys = {
    { '<F2>', function() require('dapui').eval() end, mode = 'v', desc = 'Debug: Evaluate Input' },
    { '<F5>', function() require('dap').continue() end, desc = 'Debug: Start/Continue' },
    { '<S-F5>', function() require('dap').terminate() end, desc = 'Debug: Stop' },
    { '<C-F5>', function() require('dap').restart_frame() end, desc = 'Debug: Restart' },
    { '<F6>', function() require('dap').pause() end, desc = 'Debug: Pause' },
    { '<F9>', function() require('dap').toggle_breakpoint() end, desc = 'Debug: Toggle Breakpoint' },
    { '<S-F9>', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, desc = 'Debug: Set Breakpoint' },
    { '<F10>', function() require('dap').step_over() end, desc = 'Debug: Step Over' },
    { '<F11>', function() require('dap').step_into() end, desc = 'Debug: Step Into' },
    { '<S-F11>', function() require('dap').step_out() end, desc = 'Debug: Step Out' },
    { '<leader>du', function() require('dapui').toggle() end, desc = 'Debug: Toggle Debug UI' },
    { '<leader>dh', function() require('dap.ui.widgets').hover() end, desc = 'Debug: Hover' },
    { '<leader>de', function() require('dapui').eval() end, mode = 'v', desc = 'Debug: Evaluate Input' },
    { '<leader>da', function() require('dap').set_exception_breakpoints() end, desc = 'Debug: Set Exception Breakpoints' },
    { '<leader>dc', function() require('dap').continue() end, desc = 'Debug: Start/Continue' },
    { '<leader>dQ', function() require('dap').terminate() end, desc = 'Debug: Stop' },
    { '<leader>dr', function() require('dap').restart() end, desc = 'Debug: Restart' },
    { '<leader>dp', function() require('dap').pause() end, desc = 'Debug: Pause' },
    { '<leader>dR', function() require('dap').repl.toggle() end, desc = 'Debug: Toggle REPL' },
    { '<leader>ds', function() require('dap').run_to_cursor() end, desc = 'Debug: Run to Cursor' },
    { '<leader>dB', function() require('dap').clear_breakpoints() end, desc = 'Debug: Clear Breakpoints' },
    { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'Debug: Toggle Breakpoint' },
    { '<leader>dC', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, desc = 'Debug: Set Conditional Breakpoint' },
    { '<leader>do', function() require('dap').step_over() end, desc = 'Debug: Step Over' },
    { '<leader>di', function() require('dap').step_into() end, desc = 'Debug: Step Into' },
    { '<leader>dO', function() require('dap').step_out() end, desc = 'Debug: Step Out' },
    { '<F7>', function() require('dapui').toggle() end, desc = 'Debug: Toggle UI' },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        'debugpy', -- For Python (Odoo)
        'js-debug-adapter', -- For Node.js and Deno
      },
    }

    -- Dap UI setup
    dapui.setup {
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
            { id = 'scopes', size = 0.25 },
            { id = 'breakpoints', size = 0.25 },
            { id = 'stacks', size = 0.25 },
            { id = 'watches', size = 0.25 },
          },
          position = 'right',
          size = 30,
        },
        {
          elements = { { id = 'repl', size = 0.5 }, { id = 'console', size = 0.5 } },
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

    require('dap-vscode-js').setup({
      node_path = 'node',
      debugger_path = (function()
        local mason_path = vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter/extension/out/src'
        if vim.fn.isdirectory(mason_path) then
          return mason_path
        end
        return nil
      end)(),
      adapters = { 'pwa-node', 'pwa-deno', 'pwa-msedge', 'pwa-chrome' },
      log_file = vim.fn.stdpath('cache') .. '/dap_vscode_js.log',
      log_level = 'OFF',
    })

    local function is_deno_project()
      local current_file = vim.api.nvim_buf_get_name(0)
      if current_file == "" then return false end
      local current_dir = vim.fn.fnamemodify(current_file, ':h')
      local util = require('lspconfig.util')
      return util.root_pattern('deno.json', 'deno.jsonc')(current_dir) ~= nil
    end

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
      {
        type = 'pwa-node',
        request = 'attach',
        name = 'Attach to process (Node.js)',
        processId = require('dap.utils').pick_process,
        cwd = '${workspaceFolder}',
        console = 'integratedTerminal',
        condition = function() return not is_deno_project() end,
      },
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
    dap.configurations.typescript = dap.configurations.javascript
    dap.configurations.typescriptreact = dap.configurations.javascript
    dap.configurations.javascriptreact = dap.configurations.javascript

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
