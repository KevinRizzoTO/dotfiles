vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Only lazy.nvim manages plugins. Exclude old Packer packages before the
-- first require, so Neovim cannot cache modules from that installation.
vim.opt.packpath = vim.env.VIMRUNTIME

require("config.options")
require("config.keymaps")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(require("plugins"), {
  install = { colorscheme = { "gruvbox-material" } },
  checker = { enabled = false },
  change_detection = { notify = false },
})
