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
noremap('n', '<leader>dd', [[:lua require'search.internet'.find_cword_on_any_site()<CR>]])

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

