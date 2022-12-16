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

-- python path
local python_path_list = {
    '/usr/local/bin/python3',
    '/usr/local/bin/python',
    '/usr/bin/python3',
    '/usr/bin/python',
    vim.fn.system('which python3'),
    vim.fn.system('which python'),
}
for _, python_path in ipairs(python_path_list) do
    local version
    if pcall(function ()
        version = vim.trim(vim.fn.system({
            python_path, '-c', 'import sys;print(sys.version_info.major)'
        }))
    end) then
        if version == '3' then
            vim.g.python3_host_prog = python_path
            break
        end
    end
end
