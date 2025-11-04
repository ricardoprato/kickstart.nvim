local root = require 'utils.root'
local telescope = require 'telescope.builtin'

local M = {}

-- Buscar dentro del proyecto actual (Git o cwd)
function M.project_live_grep()
  require 'redfoxd.telescope.multi-grep' { cwd = root.project_root() }
end

function M.project_find_files()
  telescope.find_files { cwd = root.project_root() }
end

-- Buscar de forma global (directorio donde abriste Neovim)
function M.global_live_grep()
  require 'redfoxd.telescope.multi-grep' { cwd = root.global_root() }
end

function M.global_find_files()
  telescope.find_files { cwd = root.global_root() }
end

return M
