local executables = require 'utils.executables'

-- suda
vim.g['suda#prefix'] = {'suda://', 'sudo://'}

-- fzf
vim.g.fd_prog = executables.find_fd_prog()

local fzf_command_args = '--type file --hidden --exclude .git --exclude node_modules'
vim.env.FZF_DEFAULT_COMMAND = vim.g.fd_prog .. ' ' .. fzf_command_args

-- telescope.nvim
local telescope = require 'telescope'
telescope.setup {defaults = {file_ignore_patterns = {'^%.git/'}}}
telescope.load_extension('fzf')

-- emmet-vim
vim.g.user_emmet_settings = {['javascript.jsx'] = {extends = 'jsx'}}

-- windowswap
vim.g.windowswap_map_keys = 0

-- vim-rainbow
vim.g.rainbow_active = 1

-- vim-livedown
vim.g.livedown_autorun = 0

-- python
vim.g.python_highlight_all = 1

vim.g['prettier#exec_cmd_path'] = 0
vim.g['prettier#exec_cmd_async'] = 1
vim.g['prettier#quickfix_auto_focus'] = 0

vim.g.UltiSnipsExpandTrigger = '<tab>'
vim.g.UltiSnipsJumpForwardTrigger = '<c-b>'
vim.g.UltiSnipsJumpBackwardTrigger = '<c-z>'
vim.g.UltiSnipsEditSplit = 'vertical'

-- theme
require('vscode').setup({italic_comments = true, underline_links = true, disable_nvimtree_bg = true})
require('vscode').load()
vim.cmd.colorscheme 'vscode'
