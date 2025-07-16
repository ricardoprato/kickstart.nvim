local M = {}
-- Método genérico para obtener la ruta al repositorio Git
M.get_git_repo_path = function()
  -- Obtener la ruta actual del buffer abierto
  local current_buffer_path = vim.fn.expand '%:p:h'
  -- Ejecutar el comando Git para obtener la ruta del repositorio
  local git_repo_path = vim.fn.system('git -C ' .. current_buffer_path .. ' rev-parse --show-toplevel')

  -- Validar si el comando Git tuvo éxito
  if vim.v.shell_error == 0 then
    -- El archivo pertenece a un repositorio Git
    return vim.trim(git_repo_path)
  else
    -- No se encontró un repositorio Git
    vim.notify('No se encontró un repositorio Git.', vim.log.levels.WARN)
    return nil
  end
end

return M
