local M = {}

-- Prefer the project's engine. Older projects use their own tsserver through
-- ts_ls; TypeScript 7 projects and standalone files use the native LSP.
function M.project(path)
  local root = vim.fs.root(path, { { "tsconfig.json", "jsconfig.json", "package.json", ".git" } })
    or vim.fs.dirname(path)
  local package = vim.fs.find("node_modules/typescript/package.json", {
    path = vim.fs.dirname(path), upward = true,
  })[1]
  if package then
    local ok, metadata = pcall(function()
      return vim.json.decode(table.concat(vim.fn.readfile(package), "\n"))
    end)
    local major = ok and tonumber((metadata.version or ""):match("^(%d+)"))
    if major then
      local directory = vim.fs.dirname(package)
      if major < 7 then
        return { root = root, server = "ts_ls", tsserver = directory .. "/lib/tsserver.js" }
      end
      return { root = root, server = "tsc", cmd = vim.fs.dirname(directory) .. "/.bin/tsc" }
    end
  end
  return { root = root, server = "tsc", cmd = "tsc" }
end

for _, name in ipairs({ "tsc", "ts_ls" }) do
  local server_name = name
  vim.lsp.config(name, {
    root_dir = function(bufnr, on_dir)
      local path = vim.api.nvim_buf_get_name(bufnr)
      local project = M.project(path)
      local deno = vim.fs.root(path, { "deno.json", "deno.jsonc", "deno.lock" })
      if deno and #deno >= #project.root then return end
      if project.server == server_name then on_dir(project.root) end
    end,
    before_init = function(_, config)
      local project = M.project(vim.fs.joinpath(config.root_dir, "index.ts"))
      if server_name == "ts_ls" then
        config.init_options = vim.tbl_deep_extend("force", config.init_options or {}, {
          tsserver = { path = project.tsserver },
        })
      end
    end,
  })
end

vim.lsp.config("tsc", {
  cmd = function(dispatchers, config)
    local project = M.project(vim.fs.joinpath(config.root_dir, "index.ts"))
    return vim.lsp.rpc.start({ project.cmd, "--lsp", "--stdio" }, dispatchers)
  end,
})
vim.lsp.enable({ "tsc", "ts_ls" })

return M
