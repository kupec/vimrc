local mappings = require'utils.mappings'
local noremap = mappings.noremap

-- escape
noremap('', '<c-c>', '<esc>')
noremap('i', '<c-c>', '<esc>')
noremap('', '<esc>', '<c-c>')
noremap('i', '<esc>', '<c-c>')

-- cancel search
noremap('n', '<leader>/', ':noh<CR>')

-- console
noremap('t', '<C-J>', '<C-\\><C-N>')

-- fast Home/End
noremap('i', 'II', '<esc>I')
noremap('i', 'AA', '<esc>A')
noremap('n', '0', '^')

-- paste current filename
noremap('i', '<C-\\><C-f><C-n>', '<C-R>=expand("%:t:r")<CR>')

-- find on internet
vim.keymap.set('n', '<leader>dd', function()
    require'search.internet'.find_cword_on_any_site()
end)

-- vim config
noremap('n', '<leader>rcl', ':so $MYVIMRC<CR>')
vim.keymap.set('n', '<leader>rco', function()
    require'search.project'.open_project_in_new_tab(vim.fn.stdpath('config'))
    vim.cmd('edit ' .. vim.env.MYVIMRC)
end)

-- project
vim.keymap.set('n', '<leader>op', function()
    local project = require 'search.project'
    project.select_project_and_run(project.open_project_in_new_tab)
end)
vim.keymap.set('n', '<leader>oo', function()
    local project = require 'search.project'
    project.select_project_and_run(project.open_project)
end)

vim.keymap.set('n', '<leader>ol', function() require'search.project'.select_tab_by_project() end)
noremap('n', '<leader>oc', ':tabc<CR>')

-- js import
vim.keymap.set('n', '<leader>ijf', function() require'import.js'.import_js_file() end)
vim.keymap.set('n', '<leader>iid', function()
    local import = require 'import.js'
    local err, project_paths = import.find_project_paths()
    if err then
        print(err)
        return
    end

    local lib_path = project_paths.node_modules / '@infra/intdev'
    local rel_lib_path = lib_path:make_relative(vim.fn.getcwd())
    import.import_js_file(tostring(rel_lib_path))
end)
vim.keymap.set('n', '<leader>ijn', function() require'import.js'.import_js_lib() end)
vim.keymap.set('n', '<leader>ijl', function() require'import.js'.import_lodash_func() end)
vim.keymap.set('n', '<leader>fif', function() require'import.js'.find_import_current_file() end)
vim.keymap.set('n', '<leader>ftt', function() require'import.js'.find_target_of_current_test_file() end)
