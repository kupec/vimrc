local which = require 'utils.which'

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.hidden = false
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.hlsearch = true
vim.opt.autoread = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.lazyredraw = true
vim.opt.background = 'light'

if vim.fn.executable('xdg-open') then
    vim.g.netrw_browsex_viewer = 'setsid xdg-open'
elseif vim.fn.executable('open') then
    vim.g.netrw_browsex_viewer = 'open'
end

vim.g.mapleader = ','

vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

vim.g.python3_host_prog = vim.fn.stdpath('config') .. '/venv/bin/python'
