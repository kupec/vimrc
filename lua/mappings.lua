local mappings = require 'utils.mappings'
local selection = require 'buffer.selection'
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

-- copy current filename/path/line
vim.api.nvim_create_user_command('CopyFileName', function(opts)
    vim.fn.setreg('+', vim.fn.expand('%:t'))
end, {})
vim.api.nvim_create_user_command('CopyFilePath', function(opts)
    vim.fn.setreg('+', vim.fn.expand('%'))
end, {})
vim.api.nvim_create_user_command('CopyFilePathWithLine', function(opts)
    vim.fn.setreg('+', vim.fn.expand('%') .. ':' .. vim.fn.line('.'))
end, {})

-- find on internet
vim.keymap.set({'n', 'v'}, '<leader>dd', function()
    local text = selection.get_smart_selection()
    require'search.internet'.find_text_on_any_site(text)
end)

-- vim config
--
noremap('n', '<leader>rcl', ':so $MYVIMRC<CR>')
vim.keymap.set('n', '<leader>rco', function()
    require'search.project'.open_project_in_new_tab(vim.fn.stdpath('config'))
    vim.cmd('edit ' .. vim.env.MYVIMRC)
end)
vim.keymap.set('n', '<leader>rcg', function()
    vim.api.nvim_create_autocmd('BufDelete', {
        pattern = '.git/COMMIT_EDITMSG',
        once = true,
        callback = function()
            vim.defer_fn(function()
                print('git pushing...')
                vim.cmd('silent Git push')
                print('git pushed')
            end, 100)
        end,
    })
    vim.cmd('Git add --all')
    vim.cmd('Git commit')
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

vim.keymap.set('n', '<leader>ol', function()
    require'search.project'.select_tab_by_project()
end)
noremap('n', '<leader>oc', ':tabc<CR>')

-- autoformatter
vim.keymap.set('n', '<leader>P', function()
    vim.cmd('w')
    vim.fn.system('yarn format')
    vim.cmd('e!')
end)

-- js import
vim.keymap.set('n', '<leader>ijf', function()
    require'import.js'.import_js_file()
end)
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
vim.keymap.set('n', '<leader>ijn', function()
    require'import.js'.import_js_lib()
end)
vim.keymap.set('n', '<leader>ijl', function()
    require'import.js'.import_lodash_func()
end)
vim.keymap.set('n', '<leader>fif', function()
    require'import.js'.find_import_current_file()
end)
vim.keymap.set('n', '<leader>ftt', function()
    require'import.js'.find_target_of_current_test_file()
end)

-- js navigation
vim.api.nvim_create_autocmd('FileType', {
    pattern = {'javascript', 'javascript.jsx', 'typescript', 'typescript.tsx'},
    callback = require 'mappings.js',
})

-- python navigation
vim.api.nvim_create_autocmd('FileType', {pattern = 'python', callback = require 'mappings.python'})

-- go navigation
vim.api.nvim_create_autocmd('FileType', {pattern = 'go', callback = require 'mappings.go'})

-- git
vim.api.nvim_create_user_command('MergetoolLocal', function(opts)
    require'git.mergetool'.show_local_diff()
end, {})
vim.api.nvim_create_user_command('MergetoolRemote', function(opts)
    require'git.mergetool'.show_remote_diff()
end, {})

-- git navigation
vim.keymap.set('n', '<leader>og', function()
    local git = require 'search.git'
    git.select_git_commit()
end)
