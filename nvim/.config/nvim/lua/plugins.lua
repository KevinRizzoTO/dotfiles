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
  use({ "tpope/vim-rhubarb" })
  use({ "tpope/vim-repeat" })
  use({ "tpope/vim-surround" })
  use({ "tpope/vim-unimpaired" })

  use({ "raimondi/delimitmate"})
  use({ "editorconfig/editorconfig-vim"})
  use({ "nelstrom/vim-visual-star-search"})

  use("dracula/vim", {as = "dracula", })
  use({"nvim-treesitter/nvim-treesitter", run = ":TSUpdate", })
  use({ "nvim-treesitter/nvim-treesitter-textobjects",  })
  use({ "neovim/nvim-lspconfig"})
  use({
    "jose-elias-alvarez/null-ls.nvim",
    requires = { "nvim-lua/plenary.nvim" },
  })
  use({"hrsh7th/nvim-cmp", requires = {
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'hrsh7th/vim-vsnip',
    'hrsh7th/cmp-vsnip'
  }})
  use("williamboman/nvim-lsp-installer")
  use({ "svermeulen/vimpeccable"})
  use({ "akinsho/nvim-toggleterm.lua"})
  use({ "b3nj5m1n/kommentary"})
  use({ "rafcamlet/nvim-luapad"})
  use({ "kyazdani42/nvim-web-devicons"})
  use({ "hoob3rt/lualine.nvim"})
  use({ 'nvim-lua/plenary.nvim'})
  use({ 'lewis6991/gitsigns.nvim'})
  use({ "kdheepak/lazygit.nvim"})
  use({ "vim-test/vim-test"})

  use({ "RRethy/nvim-treesitter-endwise" })

  -- DAP

  use({ "mfussenegger/nvim-dap"})
  use({ "nvim-telescope/telescope-dap.nvim"})
  use({ "mfussenegger/nvim-dap-python"})
  use({ "rcarriga/nvim-dap-ui"})

  use({ "hkupty/iron.nvim" })

  use({
    "folke/zen-mode.nvim",
    config = function() 
      require('zen-mode').setup({
        plugins = {
          twilight = { enabled = true }
        }
      })
    end
  })
  use({
    "folke/twilight.nvim",
    config = function() 
      require('twilight').setup()
    end
  })

  use({ "francoiscabrol/ranger.vim"})
  use({ "rbgrouleff/bclose.vim"})

  use("asvetliakov/vim-easymotion", {as = 'vsc-easymotion'})
  use({'ggandor/lightspeed.nvim', disable = vim.g.vscode == 1})

  use("kassio/neoterm")

  use('junegunn/fzf')
  use('junegunn/fzf.vim')
  use('ojroques/nvim-lspfuzzy')

  use {'kevinhwang91/nvim-bqf'}

  if packer_bootstrap then
    require('packer').install()
  end
end)
