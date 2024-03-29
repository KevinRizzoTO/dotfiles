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

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)

lsp.format_on_save({
  format_opts = {
    timeout_ms = 10000,
  },
  servers = {
    ['null-ls'] = {'javascript', 'typescript', 'lua', 'typescriptreact', 'javascriptreact'},
  }
})

lsp.format_mapping('<Leader>f', {
  format_opts = {
    async = false,
    timeout_ms = 10000,
  },
  servers = {
    ['lua_ls'] = {'lua'},
    ['rust_analyzer'] = {'rust'},
    ['null-ls'] = {'javascript', 'typescript', 'lua', 'typescriptreact', 'javascriptreact'},
  }
})

local cmp = require('cmp')
local cmp_config = lsp.defaults.cmp_config({})

local cmp_sources = lsp.defaults.cmp_sources()
table.insert(cmp_sources, { name = 'snippy' })

local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
end

local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-d>'] = cmp.mapping.scroll_docs(-4),
  ['<C-f>'] = cmp.mapping.scroll_docs(4),
  ['<C-Space>'] = cmp.mapping.complete({}),
  ['<CR>'] = cmp.mapping.confirm {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
  ['<Tab>'] = cmp.mapping(function(fallback)
    if cmp.visible() and has_words_before() then
      cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
    else
      fallback()
    end
  end, { 'i', 's' }),
  ['<S-Tab>'] = cmp.mapping(function(fallback)
    if cmp.visible() and has_words_before() then
      cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
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

cmp.event:on("menu_opened", function()
  vim.b.copilot_suggestion_hidden = true
end)

cmp.event:on("menu_closed", function()
  vim.b.copilot_suggestion_hidden = false
end)

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

local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.completion.spell,
    },
})
