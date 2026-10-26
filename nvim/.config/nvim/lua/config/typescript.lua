-- TypeScript 7 provides a native language server through `tsc --lsp`.
-- Keep this on Neovim's built-in client to avoid an LSP plugin dependency.

vim.lsp.log.set_level("debug")

vim.lsp.config("tsc", {
  cmd = { "tsc", "--lsp", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
  on_attach = function(_, bufnr)
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
  end,
})

vim.lsp.enable("tsc")
