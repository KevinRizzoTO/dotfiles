local env = require("config.python_env")

vim.api.nvim_create_user_command("PythonPath", function(command)
  env.select(command.args)
end, { nargs = "?", complete = "file", desc = "Show/set Python interpreter; use auto to reset" })

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("PythonEditing", { clear = true }),
  pattern = "python",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.tabstop = 4
  end,
})

vim.lsp.config("pyright", {
  root_markers = { { "pyrightconfig.json", "pyproject.toml", "Pipfile", "setup.py", ".git" } },
  before_init = function(_, config)
    config.settings.python.pythonPath = env.python(config.root_dir)
  end,
  settings = {
    pyright = { disableOrganizeImports = true }, -- Ruff owns import actions.
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        typeCheckingMode = "standard",
        useLibraryCodeForTypes = true,
      },
    },
  },
})

vim.lsp.config("ruff", {
  cmd = function(dispatchers, config)
    local local_ruff = vim.fs.joinpath(vim.fs.dirname(env.python(config.root_dir)), "ruff")
    local command = vim.fn.executable(local_ruff) == 1 and local_ruff or "ruff"
    return vim.lsp.rpc.start({ command, "server" }, dispatchers)
  end,
})

vim.lsp.enable({ "pyright", "ruff" })
