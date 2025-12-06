-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

return { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    { 'nvim-telescope/telescope-file-browser.nvim' },
  },
  -- REFACTOR: Changed from 'event = "VimEnter"' to 'keys' for true lazy-loading.
  -- The plugin and its configuration will only be loaded when one of these keys is pressed.
  keys = {
    {
      '<leader>sh',
      function()
        require('telescope.builtin').help_tags()
      end,
      desc = '[S]earch [H]elp',
    },
    {
      '<leader>sk',
      function()
        require('telescope.builtin').keymaps()
      end,
      desc = '[S]earch [K]eymaps',
    },
    {
      '<leader>sf',
      function()
        require('redfoxd.telescope.telescope_roots').project_find_files()
      end,
      desc = '[S]earch [F]iles',
    },
    {
      '<leader>sF',
      function()
        require('redfoxd.telescope.telescope_roots').global_find_files()
      end,
      desc = '[S]earch [F]iles (Global)',
    },
    {
      '<leader>ss',
      function()
        require('telescope.builtin').builtin()
      end,
      desc = '[S]earch [S]elect Telescope',
    },
    {
      '<leader>sw',
      function()
        require('telescope.builtin').grep_string()
      end,
      desc = '[S]earch current [W]ord',
    },
    {
      '<leader>sg',
      function()
        require('redfoxd.telescope.telescope_roots').project_live_grep()
      end,
      desc = '[S]earch by [G]rep',
    },
    {
      '<leader>sG',
      function()
        require('redfoxd.telescope.telescope_roots').global_live_grep()
      end,
      desc = '[S]earch by [G]rep (Global)',
    },
    {
      '<leader>sd',
      function()
        require('telescope.builtin').diagnostics()
      end,
      desc = '[S]earch [D]iagnostics',
    },
    {
      '<leader>sr',
      function()
        require('telescope.builtin').resume()
      end,
      desc = '[S]earch [R]esume',
    },
    {
      '<leader>s.',
      function()
        require('telescope.builtin').oldfiles()
      end,
      desc = '[S]earch Recent Files ("." for repeat)',
    },
    {
      '<leader><leader>',
      function()
        require('telescope.builtin').buffers()
      end,
      desc = '[ ] Find existing buffers',
    },
    {
      '<leader>m',
      function()
        require('telescope.builtin').man_pages()
      end,
      desc = '[S]earch man pages',
    },
    {
      '<leader>/',
      function()
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end,
      desc = '[/] Fuzzily search in current buffer',
    },
    {
      '<leader>s/',
      function()
        require('telescope.builtin').live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end,
      desc = '[S]earch [/] in Open Files',
    },
    {
      '<leader>sn',
      function()
        require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' }
      end,
      desc = '[S]earch [N]eovim files',
    },
    -- Git with Telescope
    {
      '<leader>gs',
      function()
        require('telescope.builtin').git_status()
      end,
      desc = '[G]it [S]tatus',
    },
    {
      '<leader>gc',
      function()
        require('telescope.builtin').git_commits()
      end,
      desc = '[G]it [C]ommits (Project)',
    },
    {
      '<leader>gC',
      function()
        require('telescope.builtin').git_bcommits()
      end,
      desc = '[G]it [C]ommits (Buffer)',
    },
    {
      '<leader>gb',
      function()
        require('telescope.builtin').git_branches()
      end,
      desc = '[G]it [B]ranches',
    },
    {
      '<leader>gS',
      function()
        require('telescope.builtin').git_stash()
      end,
      desc = '[G]it [S]tash',
    },
  },
  config = function()
    -- Telescope is a fuzzy finder that comes with a lot of different things that
    -- it can fuzzy find! It's more than just a "file finder", it can search
    -- many different aspects of Neovim, your workspace, LSP, and more!
    --
    -- The easiest way to use Telescope, is to start by doing something like:
    --  :Telescope help_tags
    --
    -- After running this command, a window will open up and you're able to
    -- type in the prompt window. You'll see a list of `help_tags` options and
    -- a corresponding preview of the help.
    --
    -- Two important keymaps to use while in Telescope are:
    --  - Insert mode: <c-/>
    --  - Normal mode: ?
    --
    -- This opens a window that shows you all of the keymaps for the current
    -- Telescope picker. This is really useful to discover what Telescope can
    -- do as well as how to actually do it!

    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    local actions = require 'telescope.actions'
    require('telescope').setup {
      --  All the info you're looking for is in `:help telescope.setup()`
      --
      defaults = vim.tbl_extend('force', require('telescope.themes').get_ivy(), {
        mappings = {
          i = {
            ['<c-space>'] = 'to_fuzzy_refine',
            ['<C-s>'] = actions.cycle_previewers_next,
            ['<C-a>'] = actions.cycle_previewers_prev,
          },
        },
      }),
      pickers = {
        buffers = {
          mappings = {
            i = {
              ['<C-d>'] = actions.delete_buffer + actions.move_to_top,
            },
          },
        },
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
    pcall(require('telescope').load_extension, 'file_browser')

    -- REFACTOR: Keymaps have been moved to the `keys` table for lazy-loading.
    -- The config function now only contains setup and extension loading.
  end,
}
