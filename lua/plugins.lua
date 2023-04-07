packer = require('packer')
vim.cmd [[packadd packer.nvim]]

packer.startup(function()
  use { "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim"
  }

  use { "catppuccin/nvim", as = "catppuccin" }

  use {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }
  use { "ellisonleao/gruvbox.nvim" }
  use 'nanozuki/tabby.nvim'
  use 'feline-nvim/feline.nvim'
  use { "EdenEast/nightfox.nvim", tag = "v1.0.0" } -- Packer
  use 'nanotee/sqls.nvim'
  use 'wbthomason/packer.nvim'
  use 'folke/tokyonight.nvim'
  use 'arcticicestudio/nord-vim'
  use {
    'lewis6991/gitsigns.nvim',
    -- tag = 'release' -- To use the latest release
  }
  use "lukas-reineke/indent-blankline.nvim"

  -- Lsp
  use 'neovim/nvim-lspconfig'

  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  use({ "petertriho/cmp-git", requires = "nvim-lua/plenary.nvim" })
  -- use 'williamboman/nvim-lsp-installer'
  use { 'akinsho/bufferline.nvim', tag = "v2.*", requires = 'kyazdani42/nvim-web-devicons' }
  use {
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }

  use 'nvim-tree/nvim-web-devicons'

  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use 'ryanoasis/vim-devicons'
  -- use 'preservim/nerdtree'
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icon
    },
    tag = 'nightly' -- optional, updated every week. (see issue #1193)

  }

  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  use { "akinsho/toggleterm.nvim", tag = '*', config = function()
    require("toggleterm").setup()
  end }
  use 'norcalli/nvim-colorizer.lua'

  use "rafamadriz/friendly-snippets"
  use 'saadparwaiz1/cmp_luasnip'
  use 'L3MON4D3/LuaSnip'
  use 'windwp/nvim-autopairs'
  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }

  use({
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  })

  -- install without yarn or npm

  use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install",
    setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, })
end
)
