-- suda
vim.g['suda#prefix'] = {'suda://', 'sudo://'}

-- fzf
if vim.fn.executable('fd') == 1 then
    vim.g.fd_prog = 'fd'
else
    vim.g.fd_prog = 'fdfind'
end

local fzf_command_args = '--type file --hidden --exclude .git --exclude node_modules'
vim.env.FZF_DEFAULT_COMMAND = vim.g.fd_prog .. ' ' .. fzf_command_args

-- telescope.nvim
local telescope = require 'telescope'
telescope.setup {
    defaults = {
        file_ignore_patterns = {"^%.git/"},
    },
}
telescope.load_extension('fzf')

-- emmet-vim
vim.g.user_emmet_settings = {
    ['javascript.jsx'] = {
        extends = 'jsx',
    },
}

-- ale
vim.g.ale_linters = {
    javascript = {'eslint'},
    python = {'flake8'},
}
vim.g.ale_fixers = {
    javascript = {'eslint'},
    typescript = {'eslint'},
    python = {'autopep8'},
}
vim.g.ale_fix_on_save = 0
vim.cmd [[autocmd FileType python nnoremap <buffer> <leader>p :ALEFix<CR>]]

-- windowswap
vim.g.windowswap_map_keys = 0

-- vim-rainbow
vim.g.rainbow_active = 1

-- python
vim.g.python_highlight_all = 1

vim.g['prettier#exec_cmd_path'] = 0
vim.g['prettier#exec_cmd_async'] = 1
vim.g['prettier#quickfix_auto_focus'] = 0

vim.g.UltiSnipsExpandTrigger = '<tab>'
vim.g.UltiSnipsJumpForwardTrigger = '<c-b>'
vim.g.UltiSnipsJumpBackwardTrigger = '<c-z>'
vim.g.UltiSnipsEditSplit = 'vertical'
