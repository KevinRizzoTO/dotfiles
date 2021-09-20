local cmp = require('cmp')

local vim = vim
local opt = vim.opt

opt.completeopt = 'menuone,noinsert,noselect'
vim.cmd[[set shortmess+=c]]

cmp.setup({
  -- You can set mapping if you want.
  mapping = {
    ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' }),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },

  -- You should specify your *installed* sources.
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
    { name = "vsnip" }
  },

  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end
  },
})
