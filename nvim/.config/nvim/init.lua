require('plugins')

-- alias

local vim = vim
local g = vim.g
local opt = vim.opt

local vimp = require('vimp')

-- colorscheme

vim.cmd[[colorscheme dracula]]

-- options

vim.cmd[[filetype plugin indent on]]
opt.expandtab = true

opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2

opt.hidden = true
opt.relativenumber = true
opt.timeoutlen = 250
opt.termguicolors = true
vim.cmd[[set noshowmode]]

opt.exrc = true

g.mapleader = ' '

-- lir.nvim

require('config.lir')

-- LSP

require('config.lsp')

-- nvim-cmp

require('config.nvim-cmp')

-- treesitter

local ts = require("nvim-treesitter.configs")
ts.setup({
  ensure_installed = 'maintained',
  highlight = {enable = true},
  indent = {enable = true},
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@conditional.outer",
        ["ic"] = "@conditional.inner",
        -- I don't think I've ever actually used the paragraph text object :P so why not
        ["ap"] = "@parameter.outer",
        ["ip"] = "@parameter.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner"
      },
    },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<Leader>v",
      node_incremental = ".",
      scope_incremental = ";",
      node_decremental = ",",
    },
  }
})

-- vim-ultest

g.ultest_use_pty = 1

-- TrueZen.nvim

require('true-zen').setup()

vim.api.nvim_set_keymap('n', '<Leader>z', ':TZFocus<CR>', { noremap = true, silent = true })

-- Telescope

local actions = require('telescope.actions')
local telescope = require('telescope')

telescope.setup{
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
      }
    },
    file_ignore_patterns = { ".git/.*", "node_modules" }
  }
}

vimp.nnoremap('<C-p>', function()
  require('telescope.builtin').find_files({
    hidden = true,
    follow = true
  })
end)

vimp.nnoremap('<Leader>p', function() require('telescope.builtin').commands() end)

vimp.nnoremap('<Leader>t', function() require('telescope.builtin').lsp_document_symbols() end)

vimp.nnoremap('<Leader>a', function() require('telescope.builtin').lsp_document_diagnostics() end)

vimp.nnoremap('<Leader>f', function() require('telescope.builtin').live_grep() end)

vimp.nnoremap('gr', function() require('telescope.builtin').lsp_references() end)

local actions = require("telescope.actions")

vimp.nnoremap('-', function() require('telescope.builtin').file_browser({
  hidden = true,
  initial_mode = 'normal',
  attach_mappings = function(_, map)
    map('n', 'l', actions.select_default)
    map('n', 'h', actions.move_to_bottom + actions.select_default)
    return true
  end
}) end)

-- nvim-dap

telescope.load_extension('dap')

require('dap-python').setup(vim.fn.exepath('python3'))
require('dapui').setup()

-- hop

require'hop'.setup()
vimp.nnoremap('<Leader>w', function() require('hop').hint_words() end)

-- gitsigns

require('gitsigns').setup()

-- lualine

require('lualine').setup({
  options = {
    theme = 'dracula'
  }
})

-- toggle term

require('toggleterm').setup({
  open_mapping = '<Leader>`',
  direction = 'float'
})

-- lazygit

vimp.nnoremap('<Leader>g', ':LazyGit<CR>')

-- bufferline.nvim

require("bufferline").setup({
  diagnostics = "nvim_lsp"
})

-- highlighted yank

vim.cmd[[
  augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
  augroup END
]]

-- Generic mappings

-- movement helpers

vimp.nnoremap('J', "5j")
vimp.nnoremap('K', "5k")
vimp.nnoremap('L', "w")
vimp.nnoremap('H', "b")
vimp.nnoremap('<C-j>', '<C-d>')
vimp.nnoremap('<C-k>', '<C-u>')
vim.api.nvim_set_keymap('n', '<C-l>', '$', { noremap = true, silent = true })
vimp.nnoremap('<C-h>', '^')

vimp.vnoremap('J', "5j")
vimp.vnoremap('K', "5k")
vimp.vnoremap('L', "w")
vimp.vnoremap('H', "b")
vimp.vnoremap('<C-j>', '<C-d>')
vimp.vnoremap('<C-k>', '<C-u>')
vimp.vnoremap('<C-l>', '$')
vimp.vnoremap('<C-h>', '^')

-- add extra lines in normal mode

vimp.nnoremap('<Leader>o', 'o<ESC>')
vimp.nnoremap('<Leader>O', 'O<ESC>')

-- select all in buffer

vimp.nnoremap('<C-A>', 'ggVG')

-- Move across panes

vimp.nnoremap('<Leader>h', '<C-w>h')
vimp.nnoremap('<Leader>l', '<C-w>l')
vimp.nnoremap('<Leader>j', '<C-w>j')
vimp.nnoremap('<Leader>k', '<C-w>k')

vimp.nnoremap('<Leader>/', ':noh<CR>')

vimp.nnoremap('Q', '<Nop>')
vimp.nnoremap('_', '<Nop>')

-- terminal mode

vimp.tnoremap([[<C-\>]], [[<C-\><C-n>]])
vimp.tnoremap('<C-h>', [[<C-\><C-n><C-W>h]])
vimp.tnoremap('<C-j>', [[<C-\><C-n><C-W>j]])
vimp.tnoremap('<C-k>', [[<C-\><C-n><C-W>k]])
vimp.tnoremap('<C-l>', [[<C-\><C-n><C-W>l]])

-- create new split

vimp.nnoremap([[<C-\>]], ":vsp<CR>")
vimp.nnoremap("|", ":sp<CR>")

-- tabs

vimp.nnoremap('<C-]>', ':bnext<CR>')
vimp.nnoremap('<C-[>', ':bprev<CR>')
vimp.nnoremap('<C-t>', ':tabnew<CR>')
vimp.nnoremap('<C-w>', ':Bclose<CR>')

-- clipboard

opt.clipboard = 'unnamedplus'

vimp.vnoremap('d', '"_d')
vimp.vnoremap('<Leader>d', '"+d')
vimp.vnoremap('D', '"_D')
vimp.vnoremap('<Leader>D', '"+D')
-- don't use vimp here to get around mapping conflict error
vim.api.nvim_set_keymap('v', 'dd', '"dd', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<Leader>dd', '"+dd', { noremap = true, silent = true })

vimp.nnoremap('d', '"_d')
vimp.nnoremap('<Leader>d', '"+d')
vimp.nnoremap('D', '"_D')
vimp.nnoremap('<Leader>D', '"+D')
vim.api.nvim_set_keymap('n', 'dd', '"_dd', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>dd', '"+dd', { noremap = true, silent = true })

vimp.vnoremap('c', '"_c')
vimp.vnoremap('C', '"_C')
vim.api.nvim_set_keymap('v', 'cc', '"_cc', { noremap = true, silent = true })

vimp.nnoremap('c', '"_c')
vimp.nnoremap('C', '"_C')
vim.api.nvim_set_keymap('n', 'cc', '"_cc', { noremap = true, silent = true })
