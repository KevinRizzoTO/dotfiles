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
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'tpope/vim-surround'
Plug 'nicwest/vim-http'
Plug 'airblade/vim-gitgutter'
Plug 'machakann/vim-highlightedyank'
Plug 'preservim/nerdcommenter'
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
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>

" -------------------------------------------------------------------------------------------------
" Go
" -------------------------------------------------------------------------------------------------
"
let g:go_doc_keywordprg_enabled = 0
let g:go_fmt_command = "goimports"   
let g:go_auto_type_info = 1           
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
" disable vim-go :GoDef short cut (gd)
" this is handled by LanguageClient [LC]
let g:go_def_mapping_enabled = 0
let g:go_highlight_functions = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_generate_tags = 1


" -------------------------------------------------------------------------------------------------
" NERDTree
" -------------------------------------------------------------------------------------------------
"
autocmd StdinReadPre * let s:std_in=1
" Automatically open NERDTree when starting vim on a directory
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif 
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
:nnoremap <C-b> :NERDTreeToggle<CR>

" -------------------------------------------------------------------------------------------------
" UI
" -------------------------------------------------------------------------------------------------

set relativenumber " Use relative line numbers
set rnu

" set theme
let g:dracula_italic = 0
let g:dracula_colorterm = 0
colorscheme dracula 

" set line number colour to grey
highlight LineNr ctermfg=grey 
set autowrite " Save file when switching buffers
set guifont=Fira\ Code:h12

" -------------------------------------------------------------------------------------------------
" Airline
" -------------------------------------------------------------------------------------------------

let g:airline_powerline_fonts = 1

" -------------------------------------------------------------------------------------------------
" Highlighted Yank
" -------------------------------------------------------------------------------------------------

let g:highlightedyank_highlight_duration = 100

" -------------------------------------------------------------------------------------------------
" Key Mappings
" -------------------------------------------------------------------------------------------------

" Normal Mode

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
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

" System clipboard

vnoremap <Leader>y "+y
vnoremap <Leader>x "+x
vnoremap d "_d
vnoremap <Leader>d "+d
vnoremap D "_D
vnoremap <Leader>D "+D
vnoremap dd "_dd
vnoremap <Leader>dd "+dd
vnoremap <Leader>p "+p
vnoremap <Leader>P "+P

nnoremap <Leader>y "+y
nnoremap <Leader>Y "+Y
nnoremap <Leader>yy "+yy
nnoremap <Leader>x "+x
nnoremap <Leader>dd "+dd
nnoremap d "_d
nnoremap <Leader>d "+d
nnoremap D "_D
nnoremap <Leader>D "+D
nnoremap dd "_dd
nnoremap <Leader>dd "+dd
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P

" Insert Mode
inoremap jj <Esc>

" Visual Mode
vnoremap J 5j
vnoremap K 5k
vnoremap <C-l> $
vnoremap <C-h> ^
vnoremap L w
vnoremap H b

" VS Code Parity

" Fuzzy seach for files
nnoremap <C-p> :Files<Cr>
" Search through all commands
nnoremap <Leader>p :Commands<Cr>
" Search through all document symbols
nnoremap <Leader>t :CocList outline<Cr>
" Split pane vertically
nnoremap <C-\> :vsp<CR>

" FZF

nnoremap <Leader>b :Buffers<Cr>

if has('nvim')
  " Terminal mode mappings
  tnoremap jj <C-\><C-n>

  " Move across panes and exit terminal mode
  tnoremap <C-h> <c-\><c-n><c-w>h
  tnoremap <C-j> <c-\><c-n><c-w>j
  tnoremap <C-k> <c-\><c-n><c-w>k
  tnoremap <C-l> <c-\><c-n><c-w>l

  tnoremap <Leader>y "+y
  tnoremap <Leader>Y "+Y
  tnoremap <Leader>yy "+yy
  tnoremap <Leader>p "+p
  tnoremap <Leader>P "+P

endif
