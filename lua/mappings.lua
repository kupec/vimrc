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
noremap('n', '<leader>dg', [[:execute "!" g:netrw_browsex_viewer "'https://www.google.com/search?q=<C-R><C-W>'"<CR>]])
noremap('n', '<leader>dm', [[:execute "!" g:netrw_browsex_viewer "'https://developer.mozilla.org/en-US/search?q=<C-R><C-W>'"<CR>]])
noremap('n', '<leader>dn', [[:execute "!" g:netrw_browsex_viewer "'https://www.npmjs.com/package/<C-R><C-W>'"<CR>]])
noremap('n', '<leader>dp', [[:execute "!" g:netrw_browsex_viewer "'https://docs.python.org/3/search.html?check_keywords=yes&area=default&q=<C-R><C-W>'"<CR>]])
noremap('n', '<leader>dy', [[:execute "!" g:netrw_browsex_viewer "'https://pypi.org/search/?q=<C-R><C-W>'"<CR>]])

-- vim config
noremap('n', '<leader>rcl', ':so $MYVIMRC<CR>')
noremap('n', '<leader>rco', [[
:lua require"project".open_project_in_new_tab(vim.fn.stdpath("config"))
:e $MYVIMRC
]])

-- project
noremap('n', '<leader>op', [[
:lua << EOF
local project = require 'project'
project.select_project_and_run(project.open_project_in_new_tab)
EOF
]])

noremap('n', '<leader>oo', [[
:lua << EOF
local project = require 'project'
project.select_project_and_run(project.open_project)
EOF
]])

