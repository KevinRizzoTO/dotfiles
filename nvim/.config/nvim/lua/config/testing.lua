local M = {}

-- Restrict adapters to projects that declare their runner. Their default root
-- detection accepts every package.json, which makes Jest claim Vitest projects.
function M.framework_root(path, framework)
  for _, filename in ipairs(vim.fs.find("package.json", { path = path, upward = true, limit = math.huge })) do
    local file = io.open(filename, "r")
    if file then
      local content = file:read("*a")
      file:close()
      local ok, package = pcall(vim.json.decode, content)
      if ok and type(package) == "table" then
        for _, field in ipairs({ "dependencies", "devDependencies" }) do
          if package[field] and package[field][framework] then return vim.fs.dirname(filename) end
        end
      end
    end
  end
end

function M.setup()
  local matcher = require("neotest-jest.util").defaultTestFileMatcher
  local adapters = {
    require("neotest-python")({ python = function(path) return require("config.python_env").python(path) end }),
  }
  for _, framework in ipairs({ "vitest", "jest" }) do
    local runner = framework
    local function root(path) return M.framework_root(path, runner) end
    local function is_test_file(path)
      return path ~= nil and matcher(path) and root(vim.fs.dirname(path)) ~= nil
    end
    local adapter = require("neotest-" .. runner)({
      cwd = function(path) return root(vim.fs.dirname(path)) end,
    })
    adapter.root = root
    adapter.is_test_file = is_test_file
    if runner == "jest" then
      local build_spec = adapter.build_spec
      adapter.build_spec = function(args)
        -- Jest's config lookup calls Vimscript glob(), which cannot run from
        -- an asynchronous filesystem callback on current Neovim versions.
        require("nio").scheduler()
        return build_spec(args)
      end
    end
    adapters[#adapters + 1] = adapter
  end
  require("neotest").setup({ adapters = adapters })
end

return M
