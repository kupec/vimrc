require 'plugins'
if vim.env.NVIM_INSTALL_PLUGIN_MODE == 'yes' then
    vim.cmd [[
        autocmd User PackerComplete quitall
        PackerSync
    ]]
    return
end

require 'options'
require 'plugins.lspconfig'
require 'plugins.settings'

vim.cmd 'syntax enable'



vim.cmd 'runtime legacy.init.vim'
