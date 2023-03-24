require('telescope').load_extension('vw')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', function () builtin.find_files({ find_command = {'rg', '--hidden', '--no-ignore', '--files', '-g', '!{.git,node_modules,vendor,.idea,.direnv,.vim,dist,target,sorbet}'}}) end)

vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<leader>o', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<C-f>', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

vim.keymap.set('n', '<leader>p', builtin.commands, {})

vim.keymap.set('n', '<leader>vw', function() builtin.find_files({ search_dirs = { "~/notes" } }) end)
