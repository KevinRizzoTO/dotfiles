local M = {}
local overrides = {}

function M.root(path)
  path = path or vim.api.nvim_buf_get_name(0)
  if path == "" then path = vim.fn.getcwd() end
  return vim.fs.root(path, { { "pyrightconfig.json", "pyproject.toml", "Pipfile", "setup.py", ".git" } })
    or (vim.fn.isdirectory(path) == 1 and path or vim.fs.dirname(path))
end

function M.python(path)
  local root = M.root(path)
  if overrides[root] then return overrides[root] end
  for _, name in ipairs({ ".venv", "venv" }) do
    local executable = vim.fs.joinpath(root, name, "bin", "python")
    if vim.fn.executable(executable) == 1 then return executable end
  end
  if vim.env.VIRTUAL_ENV then
    local executable = vim.fs.joinpath(vim.env.VIRTUAL_ENV, "bin", "python")
    if vim.fn.executable(executable) == 1 then return executable end
  end
  return vim.fn.exepath("python3") ~= "" and vim.fn.exepath("python3") or "python"
end

function M.select(path)
  local root = M.root()
  if path == "" then
    vim.notify(M.python(), vim.log.levels.INFO, { title = "Python interpreter" })
    return
  end
  if path ~= "auto" then
    path = vim.fn.fnamemodify(vim.fn.expand(path), ":p")
    if vim.fn.executable(path) ~= 1 then
      vim.notify("Not an executable: " .. path, vim.log.levels.ERROR)
      return
    end
  end
  overrides[root] = path ~= "auto" and path or nil
  for _, client in ipairs(vim.lsp.get_clients({ name = "pyright" })) do
    if client.config.root_dir == root then
      client.settings.python = client.settings.python or {}
      client.settings.python.pythonPath = M.python()
      client:notify("workspace/didChangeConfiguration", { settings = client.settings })
    end
  end
  vim.notify("Using " .. M.python(), vim.log.levels.INFO, { title = "Python interpreter" })
end

return M
