local vim = vim

local function apply_on_attaches(fns)
  return function(...)
    for _, fn in pairs(fns) do
      fn(...)
    end
  end
end

local lspconfig = require('lspconfig')

local function attach_lsp_to_buffer(client, bufnr)

  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  local opts = { noremap = true, silent = true }

  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<Leader>gh', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '<space>t', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setqflist()<CR>', opts)
  buf_set_keymap('n', '<space>=', '<cmd>lua vim.lsp.buf.formatting_sync(nil, 5000)<CR>', opts)
end

local null_ls = require('null-ls')

null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.completion.spell.with({
      filetypes = { "markdown" },
    }),
    null_ls.builtins.diagnostics.vale,
    null_ls.builtins.diagnostics.rubocop,
    null_ls.builtins.formatting.rubocop
  },
  on_attach = attach_lsp_to_buffer
})

local attach_fns = apply_on_attaches({ attach_lsp_to_buffer })

local server_configs = {
  solargraph = {
    autostart = false,
    on_attach = function(client, bufnr)
      -- prefer rubocop through EFM over solargraph for formatting (it seems faster)
      client.resolved_capabilities.document_formatting = false

      attach_lsp_to_buffer(client, bufnr)
    end
  },
  tsserver = {
    settings = { documentFormatting = false },
    on_attach = function(client, bufnr)
      -- prefer prettier over tsserver for formatting
      client.resolved_capabilities.document_formatting = false

      attach_lsp_to_buffer(client, bufnr)
    end
  },
  sorbet = {
    cmd = { 'bundle', 'exec', 'srb', 'tc', '--lsp' },
    filetypes = { 'ruby' },
    root_dir = lspconfig.util.root_pattern('Gemfile', '.git'),
    on_attach = attach_lsp_to_buffer,
    autostart = false
  },
  rust_analyzer = {
    on_attach = attach_lsp_to_buffer,
    settings = {
      ['rust-analyzer'] = {
        checkOnSave = {
          allFeatures = true,
          overrideCommand = {
            'cargo', 'clippy', '--workspace', '--message-format=json',
            '--all-targets', '--all-features'
          }
        }
      }
    }
  }
}

local Job = require('plenary.job')

-- TODO: use the default system API
Job:new({
  command = 'bundle',
  args = { 'exec', 'which', 'srb' },
  cwd = vim.loop.cwd(),
  on_stderr = function(j, return_val)
    -- no sorbet, use solargraph
    server_configs.solargraph.autostart = true
  end,
  on_stdout = function(j, return_val)
    -- found sorbet, use that instead
    server_configs.sorbet.autostart = true
  end
}):sync()

local lsp_installer = require("nvim-lsp-installer")

lsp_installer.on_server_ready(function(server)
  local opts = {}

  if server_configs[server.name] ~= nil then
    opts = server_configs[server.name]
  end

  -- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
  server:setup(opts)
  vim.cmd [[ do User LspAttachBuffers ]]
end)

lspconfig.sorbet.setup(server_configs.sorbet)
lspconfig.solargraph.setup(server_configs.solargraph)

vim.lsp.set_log_level("debug")

require('toggle_lsp_diagnostics').init({ virtual_text = false, update_in_insert = false })

vim.cmd([[
 command LspLogs :lua vim.cmd('e'..vim.lsp.get_log_path())
]])

-- diagnostics sign definitons

vim.fn.sign_define("DiagnosticSignError",
  { text = "", texthl = "GruvboxRed", numhl = "" })
vim.fn.sign_define("DiagnosticSignWarn",
  { text = "", texthl = "GruvboxYellow", numhl = "" })
vim.fn.sign_define("DiagnosticSignInfo",
  { text = "", texthl = "GruvboxAqua", numhl = "" })
vim.fn.sign_define("DiagnosticSignHint",
  { text = "", texthl = "GruvboxGray", numhl = "" })
