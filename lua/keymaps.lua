vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local function map(mode, lhs, rhs, args)
  vim.keymap.set(mode, lhs, rhs, args)
end

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

map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

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
