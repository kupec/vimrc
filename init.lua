require 'plugins'
if vim.env.NVIM_INSTALL_PLUGIN_MODE == 'yes' then
    vim.cmd [[
        autocmd User PackerComplete quitall
        PackerSync
    ]]
    return
end


vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.hlsearch = true
vim.opt.autoread = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.lazyredraw = true

vim.cmd 'syntax enable'

vim.g.netrw_browsex_viewer = "setsid xdg-open"

require 'plugins.lspconfig'

vim.cmd 'runtime legacy.init.vim'
