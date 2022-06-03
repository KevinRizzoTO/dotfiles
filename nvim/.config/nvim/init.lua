require('plugins')

-- alias

local vim = vim
local g = vim.g
local opt = vim.opt

local vimp = require('vimp')

-- colorscheme

local background = vim.fn.system('cat $HOME/.background')

vim.opt.background = background:gsub("\n", "")
vim.cmd[[colorscheme gruvbox]]

-- options

vim.cmd[[filetype plugin indent on]]
opt.expandtab = true

opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2

opt.hidden = true

opt.relativenumber = true
opt.number = true
opt.linebreak = true

opt.timeoutlen = 250
opt.termguicolors = true

vim.cmd[[set noshowmode]]

opt.exrc = true

opt.shell = "/bin/zsh"

g.mapleader = ' '

-- LSP

require('config.lsp')

-- nvim-cmp

require('config.nvim-cmp')

-- treesitter

local ts = require("nvim-treesitter.configs")
ts.setup({
  ensure_installed = "all",
  -- phpdoc tries to install some binary that doesn't work in ARM
  ignore_install = { "phpdoc" },
  highlight = {enable = true},
  indent = {enable = false},
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
  },
  endwise = {
    enable = true,
  }
})

-- add embedded template parser so ERB works

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()

parser_config.embedded_template = {
  install_info = {
    url = 'https://github.com/tree-sitter/tree-sitter-embedded-template',
    files =  { 'src/parser.c' },
    requires_generate_from_grammar  = true,
  },
  used_by = { 'eruby' }
}

parser_config.markdown = {
  install_info = {
    url = "https://github.com/MDeiml/tree-sitter-markdown",
    files = { "src/parser.c", "src/scanner.cc" },
  },
  filetype = "markdown",
}

-- fzf

vim.api.nvim_set_keymap("n", "<C-p>", ":Files!<CR>",
  {silent = true, noremap = true}
)

function _G._rg_fzf_search(search) 
  vim.fn['fzf#vim#grep']('rg --column --line-number --no-heading --color=always --smart-case --no-ignore --hidden -g "!{.git,node_modules,vendor,.idea,.direnv,.vim,dist,target,sorbet}" -- ' .. search, 1, vim.fn['fzf#vim#with_preview'](), 1)
end

function _G._rg_fzf_input(use_bang)
  local search = vim.fn.input("Search: ", "")

  if search == "" then
    return
  end

  _rg_fzf_search(search, use_bang)
end

vim.api.nvim_set_keymap("n", "<C-f>", ":lua _rg_fzf_input()<CR>",
  {silent = true, noremap = true}
)

vim.api.nvim_set_keymap("n", "<Leader>p", ":Commands<CR>",
  {silent = true, noremap = true}
)


vim.api.nvim_set_keymap("n", "<leader>a", ":LspDiagnostics 0<cr>",
  {silent = true, noremap = true}
)

vim.cmd([[

function! Build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('Build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'

command! -bang -nargs=* Rg :lua _rg_fzf_input(<q-args>, <bang>0)<CR>

let g:fzf_colors = {
      \ 'fg':      ['fg', 'GruvboxFg1'],
      \ 'bg':      ['fg', 'GruvboxBg0'],
      \ 'hl':      ['fg', 'GruvboxYellow'],
      \ 'fg+':     ['fg', 'GruvboxFg1'],
      \ 'bg+':     ['fg', 'GruvboxBg1'],
      \ 'hl+':     ['fg', 'GruvboxYellow'],
      \ 'info':    ['fg', 'GruvboxBlue'],
      \ 'prompt':  ['fg', 'GruvboxFg4'],
      \ 'pointer': ['fg', 'GruvboxBlue'],
      \ 'marker':  ['fg', 'GruvboxOrange'],
      \ 'spinner': ['fg', 'GruvboxYellow'],
      \ 'header':  ['fg', 'GruvboxBg3']
      \ }

]])

-- nvim-dap

require('dap-python').setup(vim.fn.exepath('python3'))
require('dapui').setup()

-- gitsigns

  require('gitsigns').setup({
  on_attach = function(bufnr)
    -- https://github.com/lewis6991/gitsigns.nvim#keymaps
    
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
    map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
})

-- lualine

require('lualine').setup({
  options = {
    theme = 'gruvbox'
  }
})

-- iron.nvim
local iron = require("iron.core")

iron.setup({
  config = {
    -- If iron should expose `<plug>(...)` mappings for the plugins
    should_map_plug = false,
    -- Whether a repl should be discarded or not
    scratch_repl = true,
    -- Your repl definitions come here
    repl_definition = {
      sh = {
        command = {"zsh"}
      },
      javascript = {
        command = {"node", "--experimental-wasi-unstable-preview1"}
      }
    },
    repl_open_cmd = "vertical botright 80 split",
  },
  -- Iron doesn't set keymaps by default anymore. Set them here
  -- or use `should_map_plug = true` and map from you vim files
  keymaps = {
    send_motion = "<space>sc",
    visual_send = "<space>sc",
    send_line = "<space>sl",
    repeat_cmd = "<space>s.",
    cr = "<space>s<cr>",
    interrupt = "<space>s<space>",
    exit = "<space>sq",
    clear = "<space>cl",
  }
})

-- toggle term

require('toggleterm').setup({
  open_mapping = '<Leader>`1',
  direction = 'float',
  shade_terminals = false
})

-- mkdx

vim.cmd[[
let g:mkdx#settings     = { 'highlight': { 'enable': 1 },
                        \ 'enter': { 'shift': 1 },
                        \ 'links': { 'external': { 'enable': 1 } },
                        \ 'toc': { 'text': 'Table of Contents', 'update_on_write': 1 },
                        \ 'fold': { 'enable': 1 } }
let g:polyglot_disabled = ['markdown'] " for vim-polyglot users, it loads Plasticboy's markdown
                                       " plugin which unfortunately interferes with mkdx list indentation.
]]

-- luasnip

require("luasnip.loaders.from_vscode").lazy_load()

-- highlighted yank

vim.cmd[[
  augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
  augroup END
]]

-- zen mode

require('zen-mode').setup()

-- for some reason, this is the only way I can get the "option" key to work
-- using the default :ZenMode command won't have the flags be applied
function _G.toggle_zen_mode()
  require('zen-mode').toggle({
    window = {
      options = {
        signcolumn = "no", -- disable signcolumn
        number = false, -- disable number column
        relativenumber = false, -- disable relative numbers
        cursorline = false, -- disable cursorline
        cursorcolumn = false, -- disable cursor column
        foldcolumn = "0", -- disable fold column
        list = false, -- disable whitespace characters
      }
    },
    plugins = {
      twilight = { enabled = true }
    }
  })
end

vimp.nnoremap('<Leader>zm', ':lua toggle_zen_mode()<CR>')

-- toggle between relative and absolute numbers

vim.cmd([[
  command ToggleRelativeNumbers :set relativenumber!
]])

-- fugitive

vim.cmd([[
  autocmd BufReadPost fugitive://* set bufhidden=delete
]])

vim.api.nvim_set_keymap("n", "<leader>g", ":tab G<CR>", {noremap = true, silent = true})

-- ranger.vim

g.ranger_replace_netrw = 1
g.ranger_map_keys = 0
g.ranger_command_override = 'ranger --cmd "set show_hidden=true"'

vim.api.nvim_set_keymap('n', '<C-b>', ':RangerCurrentFile<CR>', { noremap = true, silent = true })

-- nvim bqf

require('bqf').setup({
  preview = {
    should_preview_cb = function(bufnr)
      local filename = vim.api.nvim_buf_get_name(bufnr)

      if string.match(filename, "fugitive://") then
        return false
      end

      return true
    end
  }  
})

-- neoterm

g.neoterm_autoscroll = 1

-- Generic mappings

vim.api.nvim_set_keymap('i', 'jj', '<Esc>', { noremap = true, silent = true })

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
vimp.nnoremap('<Leader>f', ':%s//g<LEFT><LEFT>')

vimp.nnoremap('Q', '<Nop>')
vimp.nnoremap('_', '<Nop>')

-- terminal mode

vimp.tnoremap([[<C-\>]], [[<C-\><C-n>]])
vimp.tnoremap('<C-h>', [[<C-\><C-n><C-W>h]])
vimp.tnoremap('<C-j>', [[<C-\><C-n><C-W>j]])
vimp.tnoremap('<C-k>', [[<C-\><C-n><C-W>k]])
vimp.tnoremap('<C-l>', [[<C-\><C-n><C-W>l]])

vim.cmd([[
  autocmd TermOpen term://* startinsert
]])

-- create new split

vimp.nnoremap([[<C-\>]], ":vsp<CR>")
vimp.nnoremap("|", ":sp<CR>")

-- change t bindings in unimpaired to tabs instead of tags

vim.keymap.set('n', "[t", ":tabp<CR>", { noremap = true, silent = true })
vim.keymap.set('n', "]t", ":tabn<CR>", { noremap = true, silent = true })

-- buffers

vim.api.nvim_set_keymap('n', '<Leader>b', ':Buffers<CR>', { noremap = true, silent = true })

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

if vim.env.SPIN == "1" and vim.env.USER == "spin" then
  require('spin')
end
