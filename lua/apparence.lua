vim.cmd[[colorscheme gruvbox]]
require('nvim-treesitter.configs').setup{

        highlight = { enable = true},
}

require('lualine').setup{
        options = {

                theme = 'gruvbox'
        },
}

require('gitsigns').setup()
require('nvim-tree').setup{}
require('bufferline').setup{}
require('colorizer').setup()
