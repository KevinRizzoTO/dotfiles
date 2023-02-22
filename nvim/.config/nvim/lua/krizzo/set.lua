vim.cmd [[filetype plugin indent on]]
vim.opt.expandtab = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

vim.opt.hidden = true

vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.linebreak = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.timeoutlen = 250
vim.opt.termguicolors = true

vim.cmd [[set noshowmode]]

vim.opt.clipboard = "unnamedplus"

-- conceal links for orgmode (and possibility other files)
vim.opt.conceallevel = 2
