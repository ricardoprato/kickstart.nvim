vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local kitty = require 'utils.kitty'
local map = require('utils').map

map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
map('n', '[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Go to previous [D]iagnostic message' })
map('n', ']d', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Go to next [D]iagnostic message' })
map('n', '<leader>le', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
map('n', '<leader>lq', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

if vim.env.KITTY_WINDOW_ID then
  map('n', '<C-h>', function()
    kitty.navigateLeft()
  end, { desc = 'Move focus to the left split' })
  map('n', '<C-j>', function()
    kitty.navigateDown()
  end, { desc = 'Move focus to the lower split' })
  map('n', '<C-k>', function()
    kitty.navigateUp()
  end, { desc = 'Move focus to the upper split' })
  map('n', '<C-l>', function()
    kitty.navigateRight()
  end, { desc = 'Move focus to the right split' })
else
  map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
  map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
  map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
end

map('n', '<C-Up>', '<cmd>resize -2<CR>', { desc = 'Resize split up' })
map('n', '<C-Down>', '<cmd>resize +2<CR>', { desc = 'Resize split down' })
map('n', '<C-Left>', '<cmd>vertical resize -2<CR>', { desc = 'Resize split left' })
map('n', '<C-Right>', '<cmd>vertical resize +2<CR>', { desc = 'Resize split right' })

-- Move current line / block with Alt-j/k ala vscode.
map('n', '<A-k>', '<cmd>m .-2<CR>')
map('n', '<A-j>', '<cmd>m .+1<CR>')
map('i', '<A-k>', '<cmd>m .-2<CR>')
map('i', '<A-j>', '<cmd>m .+1<CR>')
map('v', '<A-k>', ":move '<-2<CR>gv=gv")
map('v', '<A-j>', ":move '>+1<CR>gv=gv")

-- QuickFix
map('n', ']q', '<cmd>cnext<CR>')
map('n', '[q', '<cmd>cprev<CR>')
map('n', '<C-q>', '<cmd>call QuickFixToggle()<CR>')

map('n', '\\', '<cmd>Lexplore<CR>', { desc = 'Save' })
map('n', '<Leader>w', '<cmd>w!<CR>', { desc = 'Save' })
map('n', '<Leader>q', '<cmd>q<CR>', { desc = 'Quit' })
map('n', '<Leader>n', '<cmd>enew<cr>', { desc = 'New file' })
map('n', 'tt', '<cmd>t.<CR>', { desc = 'Copy current line' })

-- Terminal window navigation
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
map('t', '<C-h>', '<C-\\><C-N><C-w>h')
map('t', '<C-j>', '<C-\\><C-N><C-w>j')
map('t', '<C-k>', '<C-\\><C-N><C-w>k')
map('t', '<C-l>', '<C-\\><C-N><C-w>l')

-- Better indenting
map('v', '<', '<gv')
map('v', '>', '>gv')
