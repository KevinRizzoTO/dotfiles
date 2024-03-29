let mapleader = " "

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'easymotion/vim-easymotion'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'rbong/vim-flog'
Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': 'yarn install'}
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-surround'
Plug 'airblade/vim-gitgutter'
Plug 'machakann/vim-highlightedyank'
Plug 'preservim/nerdcommenter'
Plug 'kien/rainbow_parentheses.vim'
Plug 'janko/vim-test'
Plug 'tyru/open-browser.vim'
Plug 'weirongxu/plantuml-previewer.vim'
Plug 'raimondi/delimitmate'
Plug 'wakatime/vim-wakatime'
Plug 'tpope/vim-markdown'
Plug 'Asheq/close-buffers.vim'
Plug 'AndrewRadev/linediff.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'editorconfig/editorconfig-vim'
Plug 'justinmk/vim-sneak'
Plug 'nelstrom/vim-visual-star-search'
Plug 'antoinemadec/coc-fzf'
Plug 'dense-analysis/ale'
Plug 'embear/vim-localvimrc'
Plug 'fszymanski/fzf-quickfix', {'on': 'Quickfix'}
Plug 'tpope/vim-repeat'
Plug 'metakirby5/codi.vim'
Plug 'francoiscabrol/ranger.vim'
Plug 'rbgrouleff/bclose.vim'
Plug 'kdheepak/lazygit.nvim', { 'branch': 'nvim-v0.4.3' }
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'puremourning/vimspector'
Plug 'szw/vim-maximizer'
call plug#end()

" -------------------------------------------------------------------------------------------------
" coc.nvim default settings
" -------------------------------------------------------------------------------------------------

" if hidden is not set, TextEdit might fail.
set hidden
" Better display for messages
set cmdheight=2
" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use U to show documentation in preview window
nnoremap <silent> gh :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

command CocFormat :call CocAction('format')

" -------------------------------------------------------------------------------------------------
" ALE
" -------------------------------------------------------------------------------------------------
let g:ale_disable_lsp = 1

" -------------------------------------------------------------------------------------------------
" vim-localvimrc
" -------------------------------------------------------------------------------------------------
let g:localvimrc_whitelist='.*'

" -------------------------------------------------------------------------------------------------
" fzf-quickfix
" -------------------------------------------------------------------------------------------------
nnoremap <Leader>q :Quickfix<CR>
nnoremap <Leader>a :Quickfix!<CR>

" -------------------------------------------------------------------------------------------------
" Go
" -------------------------------------------------------------------------------------------------
autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')

" -------------------------------------------------------------------------------------------------
" ranger
" -------------------------------------------------------------------------------------------------
let g:ranger_map_keys = 0
let g:ranger_replace_netrw = 1
let g:ranger_command_override = 'ranger --cmd "set show_hidden=true"'
:nnoremap <C-b> :RangerCurrentFile<CR>

" -------------------------------------------------------------------------------------------------
" UI
" -------------------------------------------------------------------------------------------------
set relativenumber " Use relative line numbers
set rnu
set termguicolors

" set theme
colorscheme dracula

" set line number colour to grey
highlight LineNr ctermfg=grey 
set autowrite " Save file when switching buffers
set guifont=Fira\ Code:h14

" reduce timeout for shorter mapping delay
set timeoutlen=200 ttimeoutlen=0

" disable swapfiles
set noswapfile

" always move words down to next line
set linebreak

filetype plugin indent on
" On pressing tab, insert 2 spaces
set expandtab
" show existing tab with 2 spaces width
set tabstop=2
set softtabstop=2
" when indenting with '>', use 2 spaces width
set shiftwidth=2

set termencoding=utf-8
set encoding=utf-8

" -------------------------------------------------------------------------------------------------
" Airline
" -------------------------------------------------------------------------------------------------
let g:airline_powerline_fonts = 1

" -------------------------------------------------------------------------------------------------
" Highlighted Yank
" -------------------------------------------------------------------------------------------------
let g:highlightedyank_highlight_duration = 100

" -------------------------------------------------------------------------------------------------
" Gitgutter
" -------------------------------------------------------------------------------------------------
let g:gitgutter_map_keys=0

" -------------------------------------------------------------------------------------------------
" autocmd
" -------------------------------------------------------------------------------------------------
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
au FileType vimwiki set syntax=markdown
autocmd BufRead,BufNewFile *.md setlocal spell

" -------------------------------------------------------------------------------------------------
" codi
" -------------------------------------------------------------------------------------------------
let g:codi#interpreters = {
                   \ 'python': {
                       \ 'bin': 'python3',
                       \ 'prompt': '^\(>>>\|\.\.\.\) ',
                       \ },
                   \ }

" -------------------------------------------------------------------------------------------------
" .vimrc
" -------------------------------------------------------------------------------------------------
command! Vimrc :e ~/.vimrc
command! VimrcReload :source ~/.vimrc

" -------------------------------------------------------------------------------------------------
" vimspector
" -------------------------------------------------------------------------------------------------
let g:vimspector_enable_mappings = 'HUMAN'

" -------------------------------------------------------------------------------------------------
" Key Mappings
" -------------------------------------------------------------------------------------------------

" Normal Mode

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
map  <Leader>e <Plug>(easymotion-bd-e)

autocmd User EasyMotionPromptBegin silent! CocDisable
autocmd User EasyMotionPromptEnd silent! CocEnable

nnoremap J 5j
nnoremap K 5k
nnoremap <C-j> <C-d>
nnoremap <C-k> <C-u>
nnoremap L w
nnoremap H b

" Move across panes
nnoremap <Leader>h <C-w>h
nnoremap <Leader>l <C-w>l
nnoremap <Leader>j <C-w>j
nnoremap <Leader>k <C-w>k

" Move to end of lines
nnoremap <C-l> $
nnoremap <C-h> ^

" Remove highlight
nnoremap <Leader>/ :noh<CR>

" Add in extra lines without going into insert mode
nnoremap <Leader>o o<Esc>
nnoremap <Leader>O O<Esc>

" Select all text in buffer
nnoremap <C-A> ggVG

" Save current buffer shortcut
nnoremap <C-s> :w<CR>

" EX mode is stupid
nnoremap Q <Nop>

" ----------------------------------------------------------------------------
" Quickfix
" ----------------------------------------------------------------------------
nnoremap ]q :cnext<cr>zz
nnoremap [q :cprev<cr>zz
nnoremap ]l :lnext<cr>zz
nnoremap [l :lprev<cr>zz

" ----------------------------------------------------------------------------
" Buffers
" ----------------------------------------------------------------------------
nnoremap ]b :bnext<cr>
nnoremap [b :bprev<cr>

" ----------------------------------------------------------------------------
" Tabs
" ----------------------------------------------------------------------------
nnoremap ]t :tabn<cr>
nnoremap [t :tabp<cr>

" ----------------------------------------------------------------------------
" Git Fugitive
" ----------------------------------------------------------------------------
nnoremap <Leader>gs :G<CR>
nnoremap <Leader>gj :diffget //3<CR>
nnoremap <Leader>gf :diffget //2<CR>

" ----------------------------------------------------------------------------
" lazygit.nvim
" ----------------------------------------------------------------------------
nnoremap <silent> <leader>lg :LazyGit<CR>


" ----------------------------------------------------------------------------
" System Clipboard
" ----------------------------------------------------------------------------

" This sends all yanks to the system clipboard (requires building vim with
" +clipboard support)
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

" Insert Mode
inoremap jj <Esc>

" Visual Mode
vnoremap J 5j
vnoremap K 5k
vnoremap <C-l> $
vnoremap <C-h> ^
vnoremap L w
vnoremap H b
 
vnoremap < <gv
vnoremap > >gv

" VS Code Parity

" Fuzzy seach for files
nnoremap <C-p> :Files<Cr>
" Start search for text in project
nnoremap <C-f> :Rg<Cr>
" Search through all commands
nnoremap <Leader>p :Commands<Cr>
" Search through all document symbols
nnoremap <Leader>t :CocFzfList outline<Cr>
" Split pane vertically
nnoremap <C-\> :vsp<CR>

" ----------------------------------------------------------------------------
" vim-sneak overrides
" ----------------------------------------------------------------------------
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T


" ----------------------------------------------------------------------------
" FZF
" ----------------------------------------------------------------------------
nnoremap <Leader>b :Buffers<Cr>

function! s:changebranch(branch) 
    execute 'Git checkout' . a:branch
    call feedkeys("i")
endfunction

command! -bang Gbranch call fzf#run({
            \ 'source': 'git branch -a --no-color | grep -v "^\* " ', 
            \ 'sink': function('s:changebranch')
            \ })

" ----------------------------------------------------------------------------
" Rainbow Parentheses
" ----------------------------------------------------------------------------
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" ----------------------------------------------------------------------------
" Terminal mode 
" ----------------------------------------------------------------------------
if has('nvim')
  " Terminal mode mappings
  autocmd TermOpen * startinsert

  " Run FZF search
  tnoremap <C-p> <C-\><C-n> :Files<CR>
  tnoremap <C-f> <C-\><C-n> :Rg<CR>

  " Move across panes and exit terminal mode
  tnoremap <Leader>h <c-\><c-n><c-w>h
  tnoremap <Leader>j <c-\><c-n><c-w>j
  tnoremap <Leader>k <c-\><c-n><c-w>k
  tnoremap <Leader>l <c-\><c-n><c-w>l

endif
