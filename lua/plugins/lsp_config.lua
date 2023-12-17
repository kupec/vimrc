local on_attach = require('plugins.lsp_config_util').on_attach
local python_paths = require 'paths.python'
local util = require 'lspconfig/util'

local servers = {
    pyright = {
        on_init = function(client)
            client.config.settings.python.pythonPath = python_paths.get_python_path(client.config.root_dir)
            client.config.settings.python.typeCheckingMode = 'strict'
        end,
        on_custom_attach = function(client)
            local python_path = python_paths.get_python_path(client.config.root_dir)
            vim.cmd.PyrightSetPythonPath(python_path)
        end
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

local function make_default_lsp_opts(lsp_opts)
    return {
        on_attach = function (client, bufnr)
            if lsp_opts.on_custom_attach then
                lsp_opts.on_custom_attach(client, bufnr)
            end
            on_attach(client, bufnr)
        end ,
        flags = {debounce_text_changes = 150},
    }
end

for lsp, lsp_opts in pairs(servers) do
    local opts = vim.tbl_extend('force', make_default_lsp_opts(lsp_opts), lsp_opts)
    require('lspconfig')[lsp].setup(opts)
end
