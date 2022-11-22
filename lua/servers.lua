local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

local servers = { 'sumneko_lua', 'jdtls', 'pyright', 'clangd', 'vimls', 'tsserver', 'cssls', 'html', 'solargraph', 'intelephense', 'jsonls', 'sqls', 'perlnavigator' }

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = servers
})

require('lspconfig').jdtls.setup{}
-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches

-- require("nvim-lsp-installer").setup{}
-- local lsp_installer = require("nvim-lsp-installer")
--
-- lsp_installer.settings({
--         ui = {
--                 icons = {
--                         server_installed = "✓",
--                         server_pending = "➜",
--                         server_uninstalled = "✗"
--                 }
--         }
-- })


local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

for _, name in pairs(servers) do
        require('lspconfig')[name].setup {
                on_attach = on_attach,
                flags = {
                        -- This will be the default in neovim 0.7+
                        debounce_text_changes = 150,
                }
        }

        require('lspconfig')[name].setup {
                capabilities = capabilities
        }

end
--
-- Lua config

local system_name
if vim.fn.has("mac") == 1 then
        system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
        system_name = "Linux"
elseif vim.fn.has('win32') == 1 then
        system_name = "Windows"
else
        print("Unsupported system for sumneko")
end

-- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
local sumneko_root_path = '/home/brunocosta/lua-language-server/'
local sumneko_binary = sumneko_root_path .. "/bin/lua-language-server"

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")


-- require 'lspconfig'.sumneko_lua.setup {
--         cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" };
--         settings = {
--                 Lua = {
--                         runtime = {
--                                 -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
--                                 version = 'LuaJIT',
--                                 -- Setup your lua path
--                                 path = runtime_path,
--                         },
--                         diagnostics = {
--                                 -- Get the language server to recognize the `vim` global
--                                 globals = { 'vim' },
--                         },
--                         workspace = {
--                                 -- Make the server aware of Neovim runtime files
--                                 library = vim.api.nvim_get_runtime_file("", true),
--                         },
--                         -- Do not send telemetry data containing a randomized but unique identifier
--                         telemetry = {
--                                 enable = false,
--                         },
--                 },
--         },
-- }
require('Comment').setup()
require('lspconfig').sqls.setup {
        on_attach = function(client, bufnr)
                require('sqls').on_attach(client, bufnr)
        end
}
