vim.cmd[[colorscheme tokyonight]]
require('nvim-treesitter.configs').setup{

        highlight = { enable = true},
}

require('lualine').setup{
        options = {

                theme = 'tokyonight'
        },
}

require('gitsigns').setup()
require('nvim-tree').setup{}
require('bufferline').setup{}
require('colorizer').setup()
