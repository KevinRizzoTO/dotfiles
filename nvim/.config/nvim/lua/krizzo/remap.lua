vim.g.mapleader = " "

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

vim.keymap.set({"n", "v"}, "c", "\"_c")
vim.keymap.set({"n", "v"}, "C", "\"_C")
vim.keymap.set({"n", "v"}, "cc", "\"_cc")

vim.keymap.set({"n", "v"}, "d", "\"_d")
vim.keymap.set({"n", "v"}, "D", "\"_D")
vim.keymap.set({"n", "v"}, "dd", "\"_dd")

vim.keymap.set({"n", "v"}, "<leader>d", "\"+d")
vim.keymap.set({"n", "v"}, "<leader>D", "\"+D")
vim.keymap.set({"n", "v"}, "<leader>dd", "\"+dd")

vim.keymap.set('t', "jk", [[<C-\><C-n>]])

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

