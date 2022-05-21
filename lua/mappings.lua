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
noremap('n', '<leader>rco', [[
:lua require"search.project".open_project_in_new_tab(vim.fn.stdpath("config"))
:e $MYVIMRC
]])

-- project
noremap('n', '<leader>op', [[
:lua << EOF
local project = require 'search.project'
project.select_project_and_run(project.open_project_in_new_tab)
EOF
]])

noremap('n', '<leader>oo', [[
:lua << EOF
local project = require 'search.project'
project.select_project_and_run(project.open_project)
EOF
]])

noremap('n', '<leader>ol', ':lua require"search.project".select_tab_by_project()<CR>')
noremap('n', '<leader>oc', ':tabc<CR>')

-- js import
noremap('n', '<leader>ijf', ':lua require"import.js".import_js_file()<CR>')
noremap('n', '<leader>iid', [[
:lua << EOF
local import = require 'import.js'
local err, project_paths = import.find_project_paths()
if err then
    print(err)
    return
end

local lib_path = project_paths.node_modules / '@infra/intdev'
local rel_lib_path = lib_path:make_relative(vim.fn.getcwd())
import.import_js_file(tostring(rel_lib_path))
EOF
]])
noremap('n', '<leader>ijn', ':lua require"import.js".import_js_lib()<CR>')
noremap('n', '<leader>ijl', ':lua require"import.js".import_lodash_func()<CR>')

