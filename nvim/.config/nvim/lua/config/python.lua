local function on_attach(_, bufnr)
  local options = { buffer = bufnr }
  local function show_diagnostic_or_hover()
    local line = vim.api.nvim_win_get_cursor(0)[1] - 1
    if #vim.diagnostic.get(bufnr, { lnum = line }) > 0 then
      vim.diagnostic.open_float(bufnr, { scope = "cursor" })
      return
    end

    vim.lsp.buf.hover()
  end

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", options, {
    desc = "Go to definition",
  }))
  vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", options, {
    desc = "Find references",
  }))
  vim.keymap.set("n", "K", show_diagnostic_or_hover, vim.tbl_extend("force", options, {
    desc = "Show diagnostic or documentation",
  }))
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", options, {
    desc = "Rename symbol",
  }))
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", options, {
    desc = "Code action",
  }))
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", options, {
    desc = "Previous diagnostic",
  }))
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", options, {
    desc = "Next diagnostic",
  }))
end

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
  on_attach = on_attach,
  settings = {
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

vim.lsp.enable("pyright")
