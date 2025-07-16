return {
  'NeogitOrg/neogit',
  config = function()
    local neogit_ok, neogit = pcall(require, 'neogit')
    if not neogit_ok then
      vim.notify('Neogit no está disponible.', vim.log.levels.WARN)
      return
    end
    local git_utils = require 'utils.git'
    vim.keymap.set('n', '<leader>gn', function()
      local repo_path = git_utils.get_git_repo_path()
      neogit.open { cwd = repo_path }
    end, { desc = 'Open neogit' })
  end,
}
