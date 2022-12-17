require 'options'
local setup_plugins = require 'plugins'

if vim.env.NVIM_INSTALL_PLUGIN_MODE == 'yes' then
    vim.env.MACOSX_DEPLOYMENT_TARGET = 11.0

    setup_plugins('install')
    vim.cmd [[
        autocmd User PackerComplete quitall
        PackerSync
    ]]
    return
end

setup_plugins()

require 'mappings'
require 'autocmds'

require 'plugins.lsp_config'
require 'plugins.settings'
require 'plugins.mappings'
require 'plugins.autocompletion'

vim.cmd 'syntax enable'
