local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true}

vim.g.mapleader = ','


-- Telescope

map('n', '<leader>ff', ':Telescope find_files<cr>', { noremap = true})
map('n', '<leader>fg', ':Telescope live_grep<cr>', { noremap = true})
map('n', '<leader>fb', ':Telescope buffers<cr>', { noremap = true})
map('n', '<leader>fh', ':Telescope help_tags<cr>', { noremap = true})


-- Terminal

map('n', '<A-d>', '<CMD>lua require("FTerm").toggle()<CR>', opts)
map('t', '<A-d>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', opts)
map('t', '<A-q>', '<C-\\><C-n><CMD>lua require("FTerm").exit()<CR>', opts)


-- Other bindings

map('n', '<C-J>', '<C-W><C-J>', opts)
map('n', '<C-K>', '<C-W><C-K>', opts)
map('n', '<C-L>', '<C-W><C-L>', opts)
map('n', '<C-H>', '<C-W><C-H>', opts)
map('n', '<Up>', ':resize +2<CR>', opts)
map('n', '<Down>', ':resize -2<CR>', opts)
map('n', '<Left>', ':vertical resize +2<CR>', opts)
map('n', '<Right>', ':vertical resize -2<CR>', opts)
map('i', 'jk', '<Esc>', opts)
map('i', 'kj', '<Esc>', opts)
map('n', "<C-s>", ":source ~/.config/nvim/init.vim<CR>", opts)
map('', '<leader>y', '"+y<CR>', opts) -- bind to yank and copy
map('', '<leader>c', '"+p<CR>', opts)
map('', '<leader>v', ':vsplit', opts)
map('', '<leader>h', ':split', opts)



-- LSP

vim.api.nvim_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
vim.api.nvim_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-ç>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)


-- NvimTree

map('n', '<C-n>', ':NvimTreeToggle<CR>', opts)
map('n', '<leader>r', ':NvimTreeRefresh<CR>', opts)
map('n', '<leader>n', ':NvimTreeFindFile<CR>', opts)

-- Bufferline
map('n', '[b', ':BufferLineCycleNext<CR>', opts)
map('n', ']b', ':BufferLineCyclePrev<CR>', opts)
