require("catppuccin").setup({
  flavour = 'mocha',
  background = {
    light = 'latte',
    dark = 'mocha'
  }



})
vim.cmd[[colorscheme catppuccin]]


require('nvim-treesitter.configs').setup{

        highlight = { enable = true},
}

require('lualine').setup{
        options = {

                theme = 'catppuccin'
        },
}

require('gitsigns').setup()
require('bufferline').setup{}
require('colorizer').setup()
require('project_nvim').setup()

require("nvim-tree").setup({
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = true
  },
})
