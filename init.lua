require 'plugins'
if vim.env.NVIM_INSTALL_PLUGIN_MODE == 'yes' then
    vim.cmd [[
        autocmd User PackerComplete quitall
        PackerSync
    ]]
    return
end

require 'options'
require 'mappings'

require 'plugins.lsp_config'
require 'plugins.settings'
require 'plugins.mappings'

vim.cmd 'syntax enable'



vim.cmd 'runtime legacy.init.vim'
