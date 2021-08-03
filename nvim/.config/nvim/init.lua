require('plugins')

-- alias

local vim = vim
local g = vim.g
local opt = vim.opt

local vimp = require('vimp')

-- colorscheme

vim.cmd[[colorscheme nord]]

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

g.mapleader = ' '

-- vim-localvimrc

g.localvimrc_whitelist = '.*'

-- ranger

g.ranger_map_keys = 0
g.ranger_replace_netrw = 1
g.ranger_command_override = 'ranger --cmd "set show_hidden=true"'

vimp.nnoremap('<C-b>', ':RangerCurrentFile<CR>')

-- LSP

local function apply_on_attaches(fns)
  return function(...)
    for _, fn in pairs(fns) do
      fn(...)
    end
  end
end

opt.completeopt = 'menuone,noinsert,noselect'
vim.cmd[[set shortmess+=c]]

local saga = require('lspsaga')
local completion_callback = require('completion').on_attach
local lspconfig = require('lspconfig')

saga.init_lsp_saga()


local function attach_keybindings(_, bufnr)
  vimp.add_buffer_maps(bufnr, function()
    -- adding to keybindings to a specific buffer isn't necessary for lspsaga
    -- do it since it is for nvim lspconfig which makes it easier to keep all bindings in one spot

    vimp.nnoremap('gd', function() require('lspsaga.provider').preview_definition() end)
    vimp.nnoremap('gh', function() require('lspsaga.hover').render_hover_doc() end)
    vimp.nnoremap('<Leader>rn', function() require('lspsaga.rename').rename() end)
    vimp.nnoremap('<C-b>', function() require('lspsaga.action').smart_scroll_with_saga(1) end)
    vimp.nnoremap('<C-f>', function() require('lspsaga.action').smart_scroll_with_saga(-1) end)
    vimp.nnoremap('<Leader>=', function() vim.lsp.buf.formatting() end)
  end)
end

local attach_fns = apply_on_attaches({ completion_callback, attach_keybindings })

local efm_language_configs = {
  python = {
    {
      formatCommand = "autopep8 -",
      formatStdin = true
    }
  }
}

local server_configs = {
  efm = {
    root_dir = lspconfig.util.root_pattern(".git"),
    filetypes = vim.tbl_keys(efm_language_configs),
    init_options = {documentFormatting = true},
    settings = {
      languages = efm_language_configs,
      rootMarkers = { ".git/" },
      log_level = 1,
      log_file = '~/efm.log'
    }
  }
}

local function setup_servers()
  require'lspinstall'.setup()
  local servers = require'lspinstall'.installed_servers()
  for _, server in pairs(servers) do
    local config = {on_attach=attach_fns}
    if (server_configs[server] ~= nil) then
      config = vim.tbl_extend("keep", config, server_configs[server])
    end
    lspconfig[server].setup(config)
  end
end

setup_servers()

require'lspinstall'.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

-- treesitter

local ts = require("nvim-treesitter.configs")
ts.setup({
  ensure_installed = 'maintained',
  highlight = {enable = true},
  indent = {enable = true}
})

-- Telescope

local actions = require('telescope.actions')

require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
      }
    },
    file_ignore_patterns = { ".git/.*" }
  }
}

-- toggle term

require('toggleterm').setup({
  open_mapping = [[<C-t>]]
})

-- lazygit

local Terminal  = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = 'float' })

vimp.nnoremap('<Leader>g', function() lazygit:toggle() end)

-- highlighted yank

vim.cmd[[
  augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
  augroup END
]]

-- Mappings

vimp.nnoremap('<C-p>', function()
  require('telescope.builtin').find_files({
    hidden = true,
    follow = true
  })
end)

vimp.nnoremap('<Leader>p', function() require('telescope.builtin').commands() end)

vimp.nnoremap('<Leader>t', function() require('telescope.builtin').lsp_document_symbols() end)

vimp.nnoremap('<Leader>a', function() require('telescope.builtin').lsp_document_diagnostics() end)

vimp.nnoremap('<Leader>w', function() require('hop').hint_words() end)

-- movement helpers

vimp.nnoremap('J', "5j")
vimp.nnoremap('K', "5k")
vimp.nnoremap('L', "w")
vimp.nnoremap('H', "b")
vimp.nnoremap('<C-j>', '<C-d>')
vimp.nnoremap('<C-k>', '<C-u>')
vimp.nnoremap('<C-l>', '$')
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

-- create new vertical split

vimp.nnoremap([[<C-\>]], ":vsp<CR>")

-- tabs

vimp.nnoremap('<C-]>', ':tabn<CR>')
vimp.nnoremap('<C-[>', ':tabp<CR>')

-- clipboard

opt.clipboard = 'unnamedplus'

vimp.vnoremap('d', '"_d')
vimp.vnoremap('<Leader>d', '"+d')
vimp.vnoremap('D', '"_D')
vimp.vnoremap('<Leader>D', '"+D')
vimp.vnoremap('dd', '"dd')
vimp.vnoremap('<Leader>dd', '"+dd')

vimp.nnoremap('d', '"_d')
vimp.nnoremap('<Leader>d', '"+d')
vimp.nnoremap('D', '"_D')
vimp.nnoremap('<Leader>D', '"+D')
vimp.nnoremap('dd', '"_dd')
vimp.nnoremap('<Leader>dd', '"+dd')

vimp.vnoremap('c', '"_c')
vimp.vnoremap('C', '"_C')
vimp.vnoremap('cc', '"_cc')

vimp.nnoremap('c', '"_c')
vimp.nnoremap('C', '"_C')
vimp.nnoremap('cc', '"_cc')
