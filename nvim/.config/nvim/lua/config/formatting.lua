local web = { "prettier" }
require("conform").setup({
  formatters_by_ft = {
    python = { "ruff_format" },
    javascript = web,
    javascriptreact = web,
    typescript = web,
    typescriptreact = web,
    json = web,
    jsonc = web,
    css = web,
    scss = web,
    html = web,
    go = { "gofmt" },
  },
  default_format_opts = { lsp_format = "never" },
  format_on_save = function(bufnr)
    if vim.b[bufnr].disable_autoformat then return end
    return { timeout_ms = 3000 }
  end,
  formatters = {
    ruff_format = {
      command = function(_, ctx)
        local path = vim.fs.joinpath(vim.fs.dirname(require("config.python_env").python(ctx.filename)), "ruff")
        return vim.fn.executable(path) == 1 and path or "ruff"
      end,
    },
    prettier = {
      -- Without a project installation, require explicit Prettier settings.
      condition = function(_, ctx)
        local local_bin = vim.fs.find("node_modules/.bin/prettier", {
          path = vim.fs.dirname(ctx.filename), upward = true,
        })[1]
        if local_bin then return true end
        if vim.fn.executable("prettier") ~= 1 then return false end
        local result = vim.system({ "prettier", "--find-config-path", ctx.filename }, { text = true }):wait(1000)
        return result.code == 0 and vim.trim(result.stdout or "") ~= ""
      end,
    },
  },
})

vim.api.nvim_create_user_command("FormatToggle", function()
  vim.b.disable_autoformat = not vim.b.disable_autoformat
  vim.notify("Autoformat " .. (vim.b.disable_autoformat and "disabled" or "enabled") .. " for this buffer")
end, { desc = "Toggle format-on-save for this buffer" })
