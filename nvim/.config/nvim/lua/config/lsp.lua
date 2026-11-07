vim.lsp.log.set_level("warn")

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("CodingLsp", { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.name == "ruff" then
      client.server_capabilities.hoverProvider = false
    end
    local function map(key, action, desc)
      vim.keymap.set("n", key, action, { buffer = event.buf, desc = desc })
    end
    map("gd", vim.lsp.buf.definition, "Go to definition")
    map("gr", vim.lsp.buf.references, "Find references")
    map("K", function()
      local line = vim.api.nvim_win_get_cursor(0)[1] - 1
      if #vim.diagnostic.get(event.buf, { lnum = line }) > 0 then
        vim.diagnostic.open_float({ scope = "line" })
      else
        vim.lsp.buf.hover()
      end
    end, "Show diagnostic or documentation")
    map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Previous diagnostic")
    map("]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next diagnostic")
    map("<leader>cd", vim.diagnostic.setloclist, "List buffer diagnostics")
  end,
})
