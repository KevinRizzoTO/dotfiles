local vim = vim

local function apply_on_attaches(fns)
  return function(...)
    for _, fn in pairs(fns) do
      fn(...)
    end
  end
end


-- local saga = require('lspsaga')
local lspconfig = require('lspconfig')

-- saga.init_lsp_saga()

local function attach_lsp_to_buffer(client, bufnr)

  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap=true, silent=true }

  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<Leader>gh', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>=', '<cmd>lua vim.lsp.buf.formatting_sync()<CR>', opts)

  -- if client.resolved_capabilities.document_formatting then
    -- vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]])
  -- end
end

local attach_fns = apply_on_attaches({ attach_lsp_to_buffer })

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
