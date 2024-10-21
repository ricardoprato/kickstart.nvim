-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    { 'nvim-tree/nvim-web-devicons' }, -- not strictly required, but recommended
    {
      '3rd/image.nvim',
      dependencies = {
        'leafo/magick',
        {
          'vhyrro/luarocks.nvim',
          opts = {
            rocks = {
              hererocks = true,
            },
          },
        },
      },
      opts = {}
    }, -- image support in preview windo
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', { desc = 'NeoTree reveal' } },
  },
  opts = {
    commands = {
      copy_selector = function(state)
        local node = state.tree:get_node()
        local filepath = node:get_id()
        local filename = node.name
        local modify = vim.fn.fnamemodify

        local vals = {
          ['BASENAME'] = modify(filename, ':r'),
          ['EXTENSION'] = modify(filename, ':e'),
          ['FILENAME'] = filename,
          ['PATH (CWD)'] = modify(filepath, ':.'),
          ['PATH (HOME)'] = modify(filepath, ':~'),
          ['PATH'] = filepath,
          ['URI'] = vim.uri_from_fname(filepath),
        }

        local options = vim.tbl_filter(function(val)
          return vals[val] ~= ''
        end, vim.tbl_keys(vals))
        if vim.tbl_isempty(options) then
          return
        end
        table.sort(options)
        vim.ui.select(options, {
          prompt = 'Choose to copy to clipboard:',
          format_item = function(item)
            return ('%s: %s'):format(item, vals[item])
          end,
        }, function(choice)
          local result = vals[choice]
          if result then
            vim.fn.setreg('+', result)
          end
        end)
      end,
      find_in_dir = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        require('telescope.builtin').live_grep {
          cwd = node.type == 'directory' and path or vim.fn.fnamemodify(path, ':h'),
        }
      end,
    }, -- A list of functions
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
          ['Y'] = 'copy_selector',
          ['F'] = 'find_in_dir',
        },
      },
      follow_current_file = {
        enabled = true, -- This will find and focus the file in the active buffer every time
      },
      use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
      -- instead of relying on nvim autocmd events.
    },
  },
}
