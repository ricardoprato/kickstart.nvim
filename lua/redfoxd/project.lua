return {
  'ahmedkhalf/project.nvim',
  config = function()
    require('project_nvim').setup {
      detection_methods = { 'pattern' },
    }
    pcall(require('telescope').load_extension 'projects')
    local ok, telescope = pcall(require, 'telescope')
    if ok then
      local function map(mode, lhs, rhs, args)
        vim.keymap.set(mode, lhs, rhs, args)
      end
      map('n', '<leader>sp', telescope.extensions.projects.projects, { desc = '[S]earch [P]rojects' })
    end
  end,
}
