-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use('wbthomason/packer.nvim')
  use('ellisonleao/gruvbox.nvim')


  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    -- or                            , branch = '0.1.x',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }

  use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })

  use('tpope/vim-fugitive')
  use('tpope/vim-rhubarb')
  use("tpope/vim-surround")
  use("tpope/vim-commentary")

  use('simrat39/rust-tools.nvim')

  use {
    'VonHeikemen/lsp-zero.nvim',
    requires = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lua' },

      -- Snippets
      { 'dcampos/nvim-snippy' },
      { 'dcampos/cmp-snippy' },
      { 'honza/vim-snippets' },
    }
  }

  use("akinsho/toggleterm.nvim")
  use('j-hui/fidget.nvim')

  use("vim-test/vim-test")

  use("jose-elias-alvarez/null-ls.nvim")
  use("lukas-reineke/lsp-format.nvim")

  use('francoiscabrol/ranger.vim')
  use('rbgrouleff/bclose.vim')

  use('nvim-lualine/lualine.nvim')

  use('lewis6991/gitsigns.nvim')

  use {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({})
    end,
  }
end)
