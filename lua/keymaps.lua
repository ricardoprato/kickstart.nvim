-- Global keymaps
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local utils = require 'utils'
local map = utils.map
local kitty = utils.kitty

-- [[ General Keymaps ]]
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

-- [[ Window / Split Navigation & Resizing ]]
if vim.env.KITTY_WINDOW_ID then
  map('n', '<C-h>', function()
    kitty.navigateLeft()
  end, { desc = 'Move focus to the left split (Kitty)' })
  map('n', '<C-j>', function()
    kitty.navigateDown()
  end, { desc = 'Move focus to the lower split (Kitty)' })
  map('n', '<C-k>', function()
    kitty.navigateUp()
  end, { desc = 'Move focus to the upper split (Kitty)' })
  map('n', '<C-l>', function()
    kitty.navigateRight()
  end, { desc = 'Move focus to the right split (Kitty)' })
else
  map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
  map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
  map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
end

map('n', '<C-Up>', '<cmd>resize -2<CR>', { desc = 'Resize split up' })
map('n', '<C-Down>', '<cmd>resize +2<CR>', { desc = 'Resize split down' })
map('n', '<C-Left>', '<cmd>vertical resize -2<CR>', { desc = 'Resize split left' })
map('n', '<C-Right>', '<cmd>vertical resize +2<CR>', { desc = 'Resize split right' })

-- Window Management
map('n', '<leader>ws', '<cmd>split<CR>', { desc = '[W]indow [S]plit horizontal' })
map('n', '<leader>wv', '<cmd>vsplit<CR>', { desc = '[W]indow [V]ertical split' })
map('n', '<leader>wc', '<cmd>close<CR>', { desc = '[W]indow [C]lose' })
map('n', '<leader>wo', '<cmd>only<CR>', { desc = '[W]indow [O]nly (close others)' })
map('n', '<leader>wh', '<C-w>h', { desc = '[W]indow move [H]left' })
map('n', '<leader>wj', '<C-w>j', { desc = '[W]indow move [J]down' })
map('n', '<leader>wk', '<C-w>k', { desc = '[W]indow move [K]up' })
map('n', '<leader>wl', '<C-w>l', { desc = 'Move [W]indow [L]right' })
map('n', '<leader>wr', '<C-w>r', { desc = '[W]indow [R]otate (swap)' })

-- [[ Buffer / File Management ]]
map('n', '<Leader>w', '<cmd>w!<CR>', { desc = 'Save current buffer' })
map('n', '<Leader>q', '<cmd>q<CR>', { desc = 'Quit current window' })
map('n', '<Leader>n', '<cmd>enew<cr>', { desc = 'Create new buffer' })
map('n', 'tt', '<cmd>t.<CR>', { desc = 'Duplicate current line' })

-- Buffer Management
map('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = '[B]uffer [D]elete' })
map('n', '<leader>bh', '<cmd>bprevious<CR>', { desc = '[B]uffer [H]ome (previous)' })
map('n', '<leader>bl', '<cmd>bnext<CR>', { desc = '[B]uffer [L]ast (next)' })
map('n', '<leader>bb', '<cmd>Telescope buffers<CR>', { desc = '[B]uffer [B]rowser (Telescope)' })
map('n', '[b', '<cmd>bprevious<CR>', { desc = '[B]uffer Previous' })
map('n', ']b', '<cmd>bnext<CR>', { desc = '[B]uffer Next' })

-- [[ Editing / Movement ]]
-- Move current line / block with Alt-j/k
map('n', '<A-k>', '<cmd>m .-2<CR>', { desc = 'Move line up' })
map('n', '<A-j>', '<cmd>m .+1<CR>', { desc = 'Move line down' })
map('i', '<A-k>', '<cmd>m .-2<CR>', { desc = 'Move line up (Insert Mode)' })
map('i', '<A-j>', '<cmd>m .+1<CR>', { desc = 'Move line down (Insert Mode)' })
map('v', '<A-k>', ":move '<-2<CR>gv=gv", { desc = 'Move selection up' })
map('v', '<A-j>', ":move '>+1<CR>gv=gv", { desc = 'Move selection down' })

-- Better indenting
map('v', '<', '<gv', { desc = 'Unindent selection' })
map('v', '>', '>gv', { desc = 'Indent selection' })

-- [[ Terminal Window Navigation ]]
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
map('t', '<C-h>', '<C-\\><C-N><C-w>h', { desc = 'Move to left window (Terminal)' })
map('t', '<C-j>', '<C-\\><C-N><C-w>j', { desc = 'Move to lower window (Terminal)' })
map('t', '<C-k>', '<C-\\><C-N><C-w>k', { desc = 'Move to upper window (Terminal)' })
map('t', '<C-l>', '<C-\\><C-N><C-w>l', { desc = 'Move to right window (Terminal)' })

-- [[ Diagnostics / Quickfix ]]
-- Note: Trouble.nvim provides a more comprehensive UI for diagnostics.
-- These are basic jumps.
map('n', '[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Go to previous [D]iagnostic message' })
map('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Go to next [D]iagnostic message' })
map('n', '<leader>do', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
map('n', '<leader>d', function()
  require('telescope.builtin').diagnostics()
end, { desc = 'Open diagnostics in telescope' })
map('n', '<leader>dt', function()
  require('trouble').toggle()
end, { desc = 'Open diagnostics in trouble' })

map('n', ']q', '<cmd>cnext<CR>', { desc = 'Next Quickfix item' })
map('n', '[q', '<cmd>cprev<CR>', { desc = 'Previous Quickfix item' })
map('n', '<C-q>', function()
  utils.QuickFixToggle()
end, { desc = 'Toggle Quickfix list' })
