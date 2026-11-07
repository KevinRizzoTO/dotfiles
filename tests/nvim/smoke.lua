local root = assert(vim.env.NVIM_SMOKE_ROOT)
local checks = 0
local function check(value, message)
  assert(value, message)
  checks = checks + 1
  print("PASS " .. message)
end
local function wait_for(predicate, message, timeout)
  check(vim.wait(timeout or 25000, predicate, 100), message)
end
local function open(path)
  vim.cmd("edit " .. vim.fn.fnameescape(root .. "/" .. path))
  return vim.api.nvim_get_current_buf()
end
local function client(name, bufnr)
  return vim.lsp.get_clients({ name = name, bufnr = bufnr })[1]
end
local function attach(name, bufnr)
  wait_for(function()
    local c = client(name, bufnr)
    return c and c.initialized
  end, name .. " attaches")
  return client(name, bufnr)
end
local function diagnostic(bufnr, pattern)
  for _, item in ipairs(vim.diagnostic.get(bufnr)) do
    if item.message:match(pattern) then return true end
  end
end
local function content() return table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n") end

local function main()
  check(not vim.fn.execute("messages"):match("Failed to run"), "startup without plugin errors")
  check(not vim.o.packpath:match("packer"), "legacy packages excluded")
  for _, tool in ipairs({ "ruff", "prettier", "vscode-eslint-language-server", "gopls", "typescript-language-server" }) do
    check(vim.fn.executable(tool) == 1, tool .. " installed")
  end

  local py = open("python/sample.py")
  local pyright = attach("pyright", py)
  local ruff = attach("ruff", py)
  local env = require("config.python_env")
  check(pyright.settings.python.pythonPath == root .. "/python/.venv/bin/python", "Pyright uses project venv")
  check(not ruff.server_capabilities.hoverProvider, "Pyright owns Python hover")
  wait_for(function() return diagnostic(py, "not assignable") or diagnostic(py, "cannot be assigned") end, "Python type diagnostics")
  wait_for(function() return diagnostic(py, "Undefined name") end, "Ruff lint diagnostics")
  vim.cmd("PythonPath " .. vim.fn.fnameescape(vim.fn.exepath("python3")))
  check(env.python() == vim.fn.exepath("python3"), "manual interpreter selection")
  vim.cmd("PythonPath auto")
  check(env.python() == root .. "/python/.venv/bin/python", "automatic interpreter reset")
  check(pyright.settings.python.pythonPath == env.python(), "Pyright follows interpreter reset")

  open("python/format.py")
  vim.cmd("write")
  check(content() == 'value = {"hello": 1}', "Ruff format-on-save")
  vim.cmd("FormatToggle")
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { "value={'hello':2}" })
  vim.cmd("write")
  check(content() == "value={'hello':2}", "format toggle preserves unformatted buffer")
  require("conform").format({ timeout_ms = 3000 })
  check(content() == 'value = {"hello": 2}', "explicit formatting works with autoformat disabled")

  local ts = open("web/sample.ts")
  attach("ts_ls", ts)
  attach("eslint", ts)
  check(not client("tsc", ts), "TypeScript 5 uses only its project tsserver")
  wait_for(function() return diagnostic(ts, "not assignable") end, "TypeScript 5 type diagnostics")
  wait_for(function() return diagnostic(ts, "Unexpected console") end, "project ESLint rules")
  check(vim.fn.maparg("<leader>ca", "n") ~= "", "shared code-action shortcut")
  open("web/format.ts")
  vim.cmd("write")
  check(content() == "const value = { hello: 'world' }", "project Prettier version and settings")

  local native = open("native/sample.ts")
  local tsc = attach("tsc", native)
  check(not client("ts_ls", native), "native TypeScript has no duplicate server")
  wait_for(function() return diagnostic(native, "not assignable") end, "native TypeScript diagnostics")
  local definition = tsc:request_sync("textDocument/definition", {
    textDocument = { uri = vim.uri_from_bufnr(native) }, position = { line = 2, character = 1 },
  }, 10000, native)
  check(definition and not definition.err and not vim.tbl_isempty(definition.result or {}), "native go-to-definition")
  local rename = tsc:request_sync("textDocument/rename", {
    textDocument = { uri = vim.uri_from_bufnr(native) }, position = { line = 0, character = 10 }, newName = "sum",
  }, 10000, native)
  check(rename and not rename.err and rename.result ~= vim.NIL and rename.result ~= nil, "native symbol rename")
  local formatters = require("conform").list_formatters_to_run(native)
  check(#formatters == 0, "unconfigured standalone TypeScript skips Prettier")

  local go = open("go/main.go")
  attach("gopls", go)
  check(pcall(vim.treesitter.get_parser, go, "go"), "Go syntax parser")
  vim.cmd("write")
  check(content():find('\t') and content():find('func main%(%) {'), "Go formatting")

  require("lazy").load({ plugins = { "neotest" } })
  local neotest = require("neotest")
  local started = false
  local function run_tests(path, adapter_name, row)
    local bufnr = open(path)
    if row then vim.api.nvim_win_set_cursor(0, { row, 0 }) end
    if started then
      wait_for(function()
        for _, id in ipairs(neotest.state.adapter_ids()) do
          if id:find(adapter_name, 1, true) then
            local counts = neotest.state.status_counts(id, { buffer = bufnr })
            if counts and counts.total == 2 then return true end
          end
        end
      end, adapter_name .. " discovers test file", 20000)
    end
    started = true
    -- Adapter IDs and counts are exposed by Neotest's public state consumer.
    if row then
      neotest.run.run()
    else
      neotest.run.run(vim.api.nvim_buf_get_name(bufnr))
    end
    local expected_failed = row and 0 or 1
    wait_for(function()
      for _, id in ipairs(neotest.state.adapter_ids()) do
        if id:find(adapter_name, 1, true) then
          local counts = neotest.state.status_counts(id, { buffer = bufnr })
          if counts and counts.running == 0 and counts.passed == 1 and counts.failed == expected_failed then return true end
        end
      end
    end, adapter_name .. (row and " nearest test" or " reports passing and failing tests"), 40000)
  end
  run_tests("python/test_sample.py", "neotest-python", 2)
  run_tests("python/test_sample.py", "neotest-python")
  run_tests("web/sample.test.ts", "neotest-vitest")
  run_tests("jest/sample.test.js", "neotest-jest")
  check(not vim.fn.execute("messages"):match("Error detected"), "no runtime errors")
  print("ALL " .. checks .. " CHECKS PASSED")
end

local ok, err = xpcall(main, debug.traceback)
if not ok then
  print(err)
  print(vim.fn.execute("messages"))
end
for _, c in ipairs(vim.lsp.get_clients()) do c:stop() end
vim.wait(5000, function() return #vim.lsp.get_clients() == 0 end, 100)
vim.cmd(ok and "qa!" or "cquit")
