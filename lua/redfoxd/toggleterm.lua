local M = {
  'akinsho/toggleterm.nvim',
  event = 'VeryLazy',
}

function M.config()
  local status_ok, toggleterm = pcall(require, 'toggleterm')
  if not status_ok then
    return
  end

  toggleterm.setup {
    size = 20,
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = 'float',
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
      border = 'curved',
    },
  }
  local user_terminals = {}
  local function toggle_term_cmd(opts)
    local terms = user_terminals
    if type(opts) == 'string' then
      opts = { cmd = opts, hidden = true }
    end
    local num = vim.v.count > 0 and vim.v.count or 1
    if not terms[opts.cmd] then
      terms[opts.cmd] = {}
    end
    if not terms[opts.cmd][num] then
      if not opts.count then
        opts.count = vim.tbl_count(terms) * 100 + num
      end
      if not opts.on_exit then
        opts.on_exit = function()
          terms[opts.cmd][num] = nil
        end
      end
      terms[opts.cmd][num] = require('toggleterm.terminal').Terminal:new(opts)
    end
    terms[opts.cmd][num]:toggle()
  end
  local function map(mode, lhs, rhs, args)
    vim.keymap.set(mode, lhs, rhs, args)
  end

  if vim.fn.executable 'lazygit' == 1 then
    map('n', '<leader>gg', function()
      toggle_term_cmd 'lazygit'
    end, { desc = 'lazy[g]it' })
  end
  if vim.fn.executable 'lazydocker' == 1 then
    map('n', '<leader>td', function()
      toggle_term_cmd 'lazydocker'
    end, { desc = '[T]oggle lazy[d]ocker' })
  end
  if vim.fn.executable 'node' == 1 then
    map('n', '<leader>tn', function()
      toggle_term_cmd 'node'
    end, { desc = '[T]oggle [n]ode' })
  end
  local python = vim.fn.executable 'python' == 1 and 'python' or vim.fn.executable 'python3' == 1 and 'python3'
  if python then
    map('n', '<leader>tp', function()
      toggle_term_cmd(python)
    end, { desc = '[T]oggle [p]ython' })
  end
end

return M
