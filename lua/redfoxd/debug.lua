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
  },
  config = function()
    local dap = require 'dap'
    local widgets = require 'dap.ui.widgets'
    local dapui = require 'dapui'
    local map = require('utils').map

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = false,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        -- 'delve',
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

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    local path = require('mason-registry').get_package('debugpy'):get_install_path()
    require('dap-python').setup(path .. '/venv/bin/python')
    local autocmd = require('utils').autocmd
    local augroup = require('utils').augroup
    -- -- Install golang specific config
    -- require('dap-go').setup {
    --   delve = {
    --     -- On Windows delve must be run attached or it crashes.
    --     -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
    --     detached = vim.fn.has 'win32' == 0,
    --   },
    -- }
    -- local autocmd = vim.api.nvim_create_autocmd
    -- local function augroup(name)
    --   return vim.api.nvim_create_augroup(name, { clear = true })
    -- end

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
