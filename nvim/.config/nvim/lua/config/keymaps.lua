vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<Esc><Cmd>write<CR>", { desc = "Save" })
vim.keymap.set("n", "<leader>w", "<Cmd>write<CR>", { desc = "Save" })
vim.keymap.set("i", "jj", "<Esc>", { desc = "Return to normal mode" })

vim.keymap.set({ "n", "x" }, "<D-z>", "u", { desc = "Undo" })
vim.keymap.set("i", "<D-z>", "<C-o>u", { desc = "Undo" })
vim.keymap.set({ "n", "x" }, "<D-S-z>", "<C-r>", { desc = "Redo" })
vim.keymap.set("i", "<D-S-z>", "<C-o><C-r>", { desc = "Redo" })

-- Preserve copied text: edits never replace the system clipboard, while yanks
-- always land there for use outside Neovim as well.
for _, mode in ipairs({ "n", "x" }) do
  vim.keymap.set(mode, "c", '"_c', { desc = "Change without yanking" })
  vim.keymap.set(mode, "d", '"_d', { desc = "Delete without yanking" })
  vim.keymap.set(mode, "x", '"_x', { desc = "Delete character without yanking" })
  vim.keymap.set(mode, "y", '"+y', { desc = "Yank to system clipboard" })
end

vim.keymap.set({ "n", "x" }, "<leader>d", '"+d', { desc = "Delete to system clipboard" })
vim.keymap.set("n", "<leader>dd", '"+dd', { desc = "Delete line to system clipboard" })

vim.keymap.set("n", "<C-p>", "<Cmd>Pick files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>o", "<Cmd>Pick lsp scope='document_symbol'<CR>", {
  desc = "Find file symbols",
})
vim.keymap.set("n", "<leader>bb", "<Cmd>Pick buffers<CR>", { desc = "Switch buffers" })
vim.keymap.set("n", "<leader>fg", "<Cmd>Pick grep_live<CR>", { desc = "Search text" })

local function open_file_browser()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    MiniFiles.open(nil, false)
    return
  end

  MiniFiles.open(path, false)
end

vim.keymap.set("n", "<leader>e", open_file_browser, { desc = "Browse files" })

local function command_palette()
  local commands = vim.fn.getcompletion("", "command")
  table.sort(commands)
  vim.ui.select(commands, {
    prompt = "Command",
    format_item = function(command)
      return ":" .. command
    end,
  }, function(command)
    if command == nil then
      return
    end
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes(":" .. command, true, false, true),
      "n",
      false
    )
  end)
end

vim.keymap.set("n", "<leader>p", command_palette, { desc = "Command palette" })

vim.keymap.set("n", "<leader>zn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", { desc = "New zk note" })
vim.keymap.set("n", "<leader>zo", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", { desc = "Open zk note" })
vim.keymap.set("n", "<leader>zb", "<Cmd>ZkBacklinks<CR>", { desc = "Zk backlinks" })
vim.keymap.set("n", "<leader>zl", "<Cmd>ZkInsertLink<CR>", { desc = "Insert zk link" })
vim.keymap.set("n", "<leader>zL", "<Cmd>ZkLinks<CR>", { desc = "Zk outbound links" })
vim.keymap.set("n", "<leader>zi", "<Cmd>ZkIndex<CR>", { desc = "Index zk notebook" })
vim.keymap.set("n", "<leader>zt", "<Cmd>ZkTags<CR>", { desc = "Zk tags" })
vim.keymap.set("n", "<leader>zf", function()
  vim.cmd("ZkNotes { match = { vim.fn.input('Search: ') } }")
end, { desc = "Search zk notes" })
vim.keymap.set("n", "<leader>zd", "<Cmd>ZkNew { dir = 'daily', group = 'daily' }<CR>", { desc = "New daily zk note" })
