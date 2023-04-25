local opts = { noremap = true, silent = true }

vim.g.mapleader = ','
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.api.nvim_set_keymap('i', 'kj', '<Esc>', opts)
vim.api.nvim_set_keymap('i', 'jk', '<Esc>', opts)

vim.api.nvim_set_keymap('', '<leader>y', '"+y<CR>', opts)
