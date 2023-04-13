require("krizzo/plugins")
require('krizzo/set')
require('krizzo/remap')

vim.g.ranger_map_keys = 1
vim.g.ranger_replace_netrw = 1

vim.keymap.set("n", "<leader>e", ":Ranger<CR>")

