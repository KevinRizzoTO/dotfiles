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
Plug 'antoinemadec/coc-fzf'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'tpope/vim-surround'
Plug 'nicwest/vim-http'
Plug 'airblade/vim-gitgutter'
Plug 'machakann/vim-highlightedyank'
Plug 'preservim/nerdcommenter'
Plug 'kien/rainbow_parentheses.vim'
Plug 'janko/vim-test'
Plug 'raimondi/delimitmate'
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
nnoremap <silent> <space>a  :<C-u>CocFzfListDiagnostics<cr>

" -------------------------------------------------------------------------------------------------
" Go
" -------------------------------------------------------------------------------------------------
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
autocmd StdinReadPre * let s:std_in=1
" Automatically open NERDTree when starting vim on a directory
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif 
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
:nnoremap <C-b> :NERDTreeToggle<CR>
" Show hidden files
let NERDTreeShowHidden=1

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
set guifont=Fira\ Code:h14

" reduce timeout for shorter mapping delay
set timeoutlen=200 ttimeoutlen=0


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
" <tab> / <s-tab> | Circular windows navigation
" ----------------------------------------------------------------------------
nnoremap <tab>   <c-w>w
nnoremap <S-tab> <c-w>W

" System clipboard

" This sends all yanks to the system clipboard (requires building vim with
" +clipboard support)
set clipboard=unnamed

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
nnoremap <Leader>t :CocFzfListOutline<Cr>
" Split pane vertically
nnoremap <C-\> :vsp<CR>


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
  
  " Escaping terminal mode
  tnoremap jj <C-\><C-n>

  " Move across panes and exit terminal mode
  tnoremap <Leader>h <c-\><c-n><c-w>h
  tnoremap <Leader>j <c-\><c-n><c-w>j
  tnoremap <Leader>k <c-\><c-n><c-w>k
  tnoremap <Leader>l <c-\><c-n><c-w>l

endif
