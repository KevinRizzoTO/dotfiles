local lsp = require("lsp-zero")

lsp.preset('lsp-compe')

lsp.ensure_installed({
  'tsserver',
  'lua_ls',
  'rust_analyzer',
})

-- Fix Undefined global 'vim'
lsp.configure('lua_ls', {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
})

lsp.configure('pyright', {
  settings = {
    python = {
      analysis = { typeCheckingMode = "off" },
    },
  }
})

local cmp = require('cmp')
local cmp_config = lsp.defaults.cmp_config({})

local cmp_sources = lsp.defaults.cmp_sources()
table.insert(cmp_sources, { name = 'snippy' })

local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-d>'] = cmp.mapping.scroll_docs(-4),
  ['<C-f>'] = cmp.mapping.scroll_docs(4),
  ['<C-Space>'] = cmp.mapping.complete({}),
  ['<CR>'] = cmp.mapping.confirm {
    behavior = cmp.ConfirmBehavior.Replace,
    select = true,
  },
  ['<Tab>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    else
      fallback()
    end
  end, { 'i', 's' }),
  ['<S-Tab>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    else
      fallback()
    end
  end, { 'i', 's' }),
})

cmp_config.mapping = cmp_mappings
cmp_config.sources = cmp_sources
cmp_config.snippet = {
  expand = function(args)
    require('snippy').expand_snippet(args.body)
  end
}

-- Disable cmp in comments
cmp_config.enabled = function()
  local is_prompt = vim.api.nvim_buf_get_option(0, "buftype") == "prompt"

  local is_comment = require('cmp.config.context').in_treesitter_capture('comment') == true
      or require('cmp.config.context').in_syntax_group('Comment')

  if is_prompt or is_comment then
    return false
  else
    return true
  end
end

cmp.setup(cmp_config)

cmp.setup.filetype("markdown", {
  sources = {
    { name = "buffer" },
  },
})

lsp.set_preferences({
  suggest_lsp_servers = false,
  sign_icons = {
    error = 'E',
    warn = 'W',
    hint = 'H',
    info = 'I'
  }
})

-- setup rust-tools
local rust_lsp = lsp.build_options('rust_analyzer', {})

lsp.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()

-- Initialize rust_analyzer with rust-tools
require('rust-tools').setup({ server = rust_lsp })

vim.diagnostic.config({
  virtual_text = true
})

require "fidget".setup({})
