M = {}

local vim = vim

-- Check if the packer tool exists
local packer_exists = pcall(vim.cmd, [[packadd packer.nvim]])

if not packer_exists then
  if vim.fn.input("Download Packer? (y for yes)") ~= "y" then
    return
  end

  local directory = string.format("%s/pack/packer/opt", vim.fn.stdpath("config"))

  vim.fn.mkdir(directory, "p")

  local out = vim.fn.system(string.format(
  "git clone %s %s",
  "https://github.com/wbthomason/packer.nvim",
  directory .. "/packer.nvim"
  ))

  print(out)
  print("Downloading packer.nvim...")

  return
end

return require("packer").startup(function()
  local use = use

  use("tpope/vim-fugitive")
  use("tpope/vim-repeat")
  use("tpope/vim-surround")

  use("janko/vim-test")
  use("raimondi/delimitmate")
  use("embear/vim-localvimrc")
  use("wakatime/vim-wakatime")
  use("editorconfig/editorconfig-vim")
  use("nelstrom/vim-visual-star-search")
  use("metakirby5/codi.vim")
  use({"francoiscabrol/ranger.vim", requires = {"rbgrouleff/bclose.vim"}})
  use("szw/vim-maximizer")
  use("shaunsingh/nord.nvim")
  use("Mofiqul/dracula.nvim")
  use({"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"})
  use("neovim/nvim-lspconfig")
  use("glepnir/lspsaga.nvim")
  use("nvim-lua/completion-nvim")
  use("kabouzeid/nvim-lspinstall")
  use("svermeulen/vimpeccable")
  use("akinsho/nvim-toggleterm.lua")
  use("ggandor/lightspeed.nvim")
  use("b3nj5m1n/kommentary")
  use("rafcamlet/nvim-luapad")
  use({
    'phaazon/hop.nvim',
    as = 'hop'
  })
  use({
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
  })
end)
