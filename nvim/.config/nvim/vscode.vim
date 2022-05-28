let mapleader = " "

lua << EOF

require('plugins')

local ts = require("nvim-treesitter.configs")

ts.setup({
  ensure_installed = 'all',
  indent = {enable = false},
  -- phpdoc tries to install some binary that doesn't work in ARM
  ignore_install = { "phpdoc" },
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

EOF

map <Leader>w <Plug>(easymotion-bd-w)

augroup highlight_yank
  autocmd!
  au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
augroup END

map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T

xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine

nnoremap J 5j
nnoremap K 5k
nnoremap <C-l> $
nnoremap <C-h> ^
nnoremap <C-j> <C-d>
nnoremap <C-k> <C-u>
nnoremap L w
nnoremap H b

vnoremap J 5j
vnoremap K 5k
vnoremap <C-l> $
vnoremap <C-h> ^
vnoremap <C-j> <C-d>
vnoremap <C-k> <C-u>
vnoremap L w
vnoremap H b

nnoremap <Leader>/ :noh<CR>

nnoremap <Leader>o o<Esc>
nnoremap <Leader>O O<Esc>

set clipboard=unnamedplus

vnoremap d "_d
vnoremap <Leader>d "+d
vnoremap D "_D
vnoremap <Leader>D "+D
vnoremap dd "_dd
vnoremap <Leader>dd "+dd

nnoremap d "_d
nnoremap <Leader>d "+d
nnoremap D "_D
nnoremap <Leader>D "+D
nnoremap dd "_dd
nnoremap <Leader>dd "+dd

vnoremap c "_c
vnoremap C "_C
vnoremap cc "_cc

nnoremap c "_c
nnoremap C "_C
nnoremap cc "_cc

nnoremap <Leader>h <Cmd>call VSCodeNotify('workbench.action.navigateLeft')<CR>
nnoremap <Leader>l <Cmd>call VSCodeNotify('workbench.action.navigateRight')<CR>
nnoremap <Leader>j <Cmd>call VSCodeNotify('workbench.action.navigateDown')<CR>
nnoremap <Leader>k <Cmd>call VSCodeNotify('workbench.action.navigateUp')<CR>

nnoremap <Leader>t <Cmd>call VSCodeNotify('workbench.action.gotoSymbol')<CR>
nnoremap <Leader>p <Cmd>call VSCodeNotify('workbench.action.showCommands')<CR>
