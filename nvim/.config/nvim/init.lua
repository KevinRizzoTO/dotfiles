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
opt.number = true

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

-- TrueZen.nvim

require('true-zen').setup()

vim.api.nvim_set_keymap('n', '<Leader>z', ':TZFocus<CR>', { noremap = true, silent = true })

-- fzf

vim.api.nvim_set_keymap("n", "<C-p>", ":Files!<CR>",
  {silent = true, noremap = true}
)

function _G._rg_fzf_search(search) 
  vim.fn['fzf#vim#grep']('rg --column --line-number --no-heading --color=always --smart-case --no-ignore --hidden -g "!{.git,node_modules,vendor,.idea,.direnv,.vim,dist}" -- ' .. search, 1, vim.fn['fzf#vim#with_preview'](), 1)
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

]])

-- nvim-dap

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
  direction = 'float',
  shade_terminals = false
})

-- bufferline.nvim

require("bufferline").setup({
  options = {
    custom_filter = function(buf_number)
      local buf_name = vim.fn.bufname(buf_number)

      -- ranger buffers when visible are hard to get rid of
      -- buffer names have pattern of $PORT:ranger in them
      if string.match(buf_name, '%d+:ranger') or vim.bo[buf_number].filetype == 'qf' then
        return false
      end

      return true
    end,
    diagnostics = "nvim_lsp",
    groups = {
      options = {
        toggle_hidden_on_enter = true -- when you re-enter a hidden group this options re-opens that group so the buffer is visible
      },
      items = {
        {
          name = "Tests", -- Mandatory
          priority = 2, -- determines where it will appear relative to other groups (Optional)
          icon = "", -- Optional
          matcher = function(buf) -- Mandatory
            return buf.filename:match('%_test') or buf.filename:match('%_spec')
          end,
        },
        {
          name = "Docs",
          auto_close = false,  -- whether or not close this group if it doesn't contain the current buffer
          matcher = function(buf)
            return buf.filename:match('%.md') or buf.filename:match('%.txt')
          end,
        },
        {
          name = "Terminals",
          matcher = function(buf)
            return buf.buftype == 'terminal'
          end
        }
      }
    },
    show_close_icons = false,
    show_buffer_close_icons = false
  }
})

-- highlighted yank

vim.cmd[[
  augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
  augroup END
]]

-- vim-sneak

vim.cmd[[
  map f <Plug>Sneak_f
  map F <Plug>Sneak_F
  map t <Plug>Sneak_t
  map T <Plug>Sneak_T
]]

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

-- custom commands

local running_terms = {}

function _G._run_command(cmd)
  local cmdTerm
  if running_terms[cmd] ~= nil then
    cmdTerm = running_terms[cmd]
  else
    local Terminal  = require('toggleterm.terminal').Terminal

    cmdTerm = Terminal:new({
      cmd = cmd,
      direction = "float",
      dir = vim.loop.cwd(),
      close_on_exit = false,
      on_open = function(term)
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
      end,
      on_exit = function(term)
        running_terms[cmd] = nil
      end
    })

    running_terms[cmd] = cmdTerm
  end

  cmdTerm:open()
end

vim.cmd([[
  command -nargs=+ Dev :lua _run_command("/opt/dev/bin/dev " .. <q-args>)
]])

vim.cmd([[
  command -nargs=+ Run :lua _run_command(<q-args>)
]])

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
vimp.nnoremap('<Leader>f', ':%s//g<LEFT><LEFT>')

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

vimp.nnoremap(']b', ':BufferLineCycleNext<CR>')
vimp.nnoremap('[b', ':BufferLineCyclePrev<CR>')
vimp.nnoremap('bc', ':Bclose!<CR>')

-- quickfix

vimp.nnoremap(']q', ':cnext<CR>')
vimp.nnoremap('[q', ':cprev<CR>')
vimp.nnoremap('[Q', ':first<CR>')
vimp.nnoremap(']Q', ':clast<CR>')

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
