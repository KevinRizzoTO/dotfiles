local M = {}

function M.setup_mappings(bufnr)
  if vim.bo[bufnr].filetype ~= "markdown" then
    return
  end

  vim.keymap.set("n", "<leader>tt", "<Cmd>AutolistToggleCheckbox<CR>", {
    buffer = bufnr,
    desc = "Toggle todo item",
  })
  vim.keymap.set("i", "<CR>", "<CR><Cmd>AutolistNewBullet<CR>", {
    buffer = bufnr,
    desc = "Continue Markdown list",
  })
  vim.keymap.set("i", "[", "[", {
    buffer = bufnr,
    desc = "Leave wiki-link brackets to Zk completion",
  })
  vim.keymap.set("i", "<Tab>", function()
    if vim.fn.pumvisible() == 1 then
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes("<C-n>", true, false, true),
        "n",
        false
      )
      return
    end

    local line = vim.api.nvim_get_current_line()
    local is_list_item = line:match("^%s*[-+*]%s")
      or line:match("^%s*%d+[.)]%s")

    if is_list_item then
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes("<C-t><Cmd>AutolistRecalculate<CR>", true, false, true),
        "n",
        false
      )
      return
    end

    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<Tab>", true, false, true),
      "n",
      false
    )
  end, {
    buffer = bufnr,
    desc = "Select completion, indent a list, or insert a tab",
  })
  vim.keymap.set("i", "<S-Tab>", "<C-d><Cmd>AutolistRecalculate<CR>", {
    buffer = bufnr,
    desc = "Dedent Markdown list item",
  })
end

return M
