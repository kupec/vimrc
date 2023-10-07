local on_attach = require('plugins.lsp_config_util').on_attach
local python_paths = require 'paths.python'
local util = require 'lspconfig/util'

local servers = {
    pyright = {
        on_init = function(client)
            client.config.settings.python.pythonPath = python_paths.get_python_path(client.config.root_dir)
            client.config.settings.python.typeCheckingMode = 'strict'
        end,
    },
    tsserver = {},
    lua_ls = {
        settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT',
                },
                workspace = {
                    checkThirdParty = false,
                    library = {
                      vim.env.VIMRUNTIME
                    }
                },
            },
        },
    },
}

require('mason').setup()
require('mason-lspconfig').setup {ensure_installed = vim.tbl_keys(servers)}

local default_lsp_opts = {on_attach = on_attach, flags = {debounce_text_changes = 150}}

for lsp, lsp_opts in pairs(servers) do
    local opts = vim.tbl_extend('force', default_lsp_opts, lsp_opts)
    require('lspconfig')[lsp].setup(opts)
end
