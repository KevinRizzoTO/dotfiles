-- This Neovim profile is intentionally for writing and fast text editing.
-- TypeScript and Python use Neovim's built-in LSP client.
-- It does not install a debugger, formatter, file-tree, or project-management
-- plugin.
vim.env.ZK_NOTEBOOK_DIR = "/Users/kevinrizzo/dev/zk-notes"

local opt = vim.opt
opt.clipboard = "unnamedplus"
opt.cmdheight = 0
opt.completeopt = { "menu", "menuone", "noselect", "popup" }
opt.confirm = true
opt.cursorline = true
opt.cursorlineopt = "number"
opt.breakindent = true
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"
opt.linebreak = true
opt.number = true
opt.numberwidth = 4
opt.relativenumber = true
opt.scrolloff = 5
opt.signcolumn = "yes"
opt.shiftwidth = 2
opt.showbreak = "↳ "
opt.smartindent = true
opt.smoothscroll = true
opt.softtabstop = 2
opt.splitbelow = true
opt.splitright = true
opt.tabstop = 2
opt.undofile = true
opt.updatetime = 250
opt.wrap = true

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.textwidth = 0
  end,
})

local yank_highlight_group = vim.api.nvim_create_augroup("HighlightYank", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = yank_highlight_group,
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
  end,
})
