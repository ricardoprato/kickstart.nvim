-- "gc" to comment visual regions/lines
return { -- Adds git related signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',
  -- REFACTOR: Lazy-load on file open events
  event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
  opts = {
    signs = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '▎' },
      topdelete = { text = '▎' },
      changedelete = { text = '▎' },
      untracked = { text = '┆' },
    },
    on_attach = function(bufnr)
      local gitsigns = require 'gitsigns'
      local utils = require 'utils'
      local map = utils.map

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal { ']c', bang = true }
        else
          gitsigns.nav_hunk 'next'
        end
      end, { desc = 'Jump to next git [c]hange' })

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
        else
          gitsigns.nav_hunk 'prev'
        end
      end, { desc = 'Jump to previous git [c]hange' })

      -- Actions
      -- visual mode
      map('v', '<leader>hs', function()
        gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'stage git hunk' })
      map('v', '<leader>hr', function()
        gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'reset git hunk' })
      -- normal mode
      map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
      map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
      map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
      map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
      map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
      map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
      map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
      map('n', '<leader>hD', function()
        gitsigns.diffthis '@'
      end, { desc = 'git [D]iff against last commit' })
      map('n', '<leader>gb', gitsigns.blame_line, { desc = 'git [g]lobal [b]lame line' })
      map('n', '<leader>gn', function()
        gitsigns.nav_hunk 'next'
      end, { desc = 'git [g]lobal [n]ext hunk' })
      map('n', '<leader>gp', function()
        gitsigns.nav_hunk 'prev'
      end, { desc = 'git [g]lobal [p]revious hunk' })

      map('n', '<leader>hQ', function()
        gitsigns.setqflist 'all'
      end, { desc = 'Add all changed files to Quickfix list' })
      map('n', '<leader>hq', gitsigns.setqflist, { desc = 'Add changed files to Quickfix list' })

      -- Toggles
      map('n', '<leader>ub', gitsigns.toggle_current_line_blame, { desc = 'Toggle git show [b]lame line' })
      map('n', '<leader>uD', gitsigns.toggle_deleted, { desc = 'Toggle git show [D]eleted' })
      map('n', '<leader>uw', gitsigns.toggle_word_diff, { desc = 'Toggle [w]ord diff' })

      -- Text object
      map({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
    end,
  },
}
