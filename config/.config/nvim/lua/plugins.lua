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


  use("raimondi/delimitmate")
  use("wakatime/vim-wakatime")
  use("editorconfig/editorconfig-vim")
  use("nelstrom/vim-visual-star-search")
  use("metakirby5/codi.vim")
  use("Pocco81/TrueZen.nvim")
  use("dracula/vim", {as = "dracula"})
  use("shaunsingh/nord.nvim")
  use({"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"})
  use("nvim-treesitter/nvim-treesitter-textobjects")
  use("neovim/nvim-lspconfig")
  use({"hrsh7th/nvim-cmp", requires = {
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'hrsh7th/vim-vsnip',
    'hrsh7th/cmp-vsnip'
  }})
  use("kabouzeid/nvim-lspinstall")
  use("svermeulen/vimpeccable")
  use("akinsho/nvim-toggleterm.lua")
  use("b3nj5m1n/kommentary")
  use("rafcamlet/nvim-luapad")
  use("kyazdani42/nvim-web-devicons")
  use("hoob3rt/lualine.nvim")
  use({
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    }
  })
  use('kdheepak/lazygit.nvim')
  use({
    'phaazon/hop.nvim',
    as = 'hop'
  })
  use({
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
  })
  use("vim-test/vim-test")

  -- DAP

  use('mfussenegger/nvim-dap')
  use('nvim-telescope/telescope-dap.nvim')
  use('mfussenegger/nvim-dap-python')
  use('rcarriga/nvim-dap-ui')

  use("tamago324/lir.nvim")

  use("akinsho/bufferline.nvim")

  use("rbgrouleff/bclose.vim")
  use("dm1try/golden_size")

  use("justinmk/vim-sneak")
end)
