require 'options'
local plugins = require 'plugins'

if vim.env.NVIM_INSTALL_PLUGIN_MODE == 'yes' then
    plugins.install()
    return
end

plugins.init()

require 'mappings'
require 'autocmds'

require 'plugins.lsp_config'
require 'plugins.settings'
require 'plugins.mappings'
require 'plugins.autocompletion'

vim.cmd 'syntax enable'
