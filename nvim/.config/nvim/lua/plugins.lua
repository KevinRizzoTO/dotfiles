local vim = vim

local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end

return require("packer").startup(function()
  local use = use

  use({'wbthomason/packer.nvim'})

  use({ "tpope/vim-fugitive" })
  use({ "tpope/vim-repeat" })
  use({ "tpope/vim-surround" })


  use({ "raimondi/delimitmate", lock = true })
  use({ "editorconfig/editorconfig-vim", lock = true })
  use({ "nelstrom/vim-visual-star-search", lock = true })
  use({ "Pocco81/TrueZen.nvim", lock = true })
  use("dracula/vim", {as = "dracula", lock = true})
  use({"nvim-treesitter/nvim-treesitter", run = ":TSUpdate", lock = true})
  use({ "nvim-treesitter/nvim-treesitter-textobjects", lock = true })
  use({ "neovim/nvim-lspconfig", lock = true })
  use({"hrsh7th/nvim-cmp", lock = true, requires = {
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'hrsh7th/vim-vsnip',
    'hrsh7th/cmp-vsnip'
  }})
  use("williamboman/nvim-lsp-installer")
  use({ "svermeulen/vimpeccable", lock = true })
  use({ "akinsho/nvim-toggleterm.lua", lock = true })
  use({ "b3nj5m1n/kommentary", lock = true })
  use({ "rafcamlet/nvim-luapad", lock = true })
  use({ "kyazdani42/nvim-web-devicons", lock = true })
  use({ "hoob3rt/lualine.nvim", lock = true })
  use({ 'nvim-lua/plenary.nvim', lock = true})
  use({
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    lock = true
  })
  use({ "kdheepak/lazygit.nvim", lock = true })
  use({ "vim-test/vim-test", lock = true })

  -- DAP

  use({ "mfussenegger/nvim-dap", lock = true })
  use({ "nvim-telescope/telescope-dap.nvim", lock = true })
  use({ "mfussenegger/nvim-dap-python", lock = true })
  use({ "rcarriga/nvim-dap-ui", lock = true })

  use({ "francoiscabrol/ranger.vim"})
  use({ "rbgrouleff/bclose.vim", lock = true })


  use("asvetliakov/vim-easymotion", {as = 'vsc-easymotion', lock = true})
  use({
    'phaazon/hop.nvim',
    as = 'hop',
    lock = true
  })
  use('ggandor/lightspeed.nvim')

  use("kassio/neoterm")

  use('junegunn/fzf')
  use('junegunn/fzf.vim')
  use('ojroques/nvim-lspfuzzy')

  use {'kevinhwang91/nvim-bqf'}

  if packer_bootstrap then
    require('packer').install()
  end
end)
