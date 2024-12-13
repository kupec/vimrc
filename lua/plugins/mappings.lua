local mappings = require 'utils.mappings'
local selection = require 'buffer.selection'
local noremap = mappings.noremap
local map = mappings.map

-- vim-easymotion
map('n', '<leader>m', '<Plug>(easymotion-overwin-f2)')

-- vim-windowswap
noremap('n', '<leader>ww', ':call WindowSwap#EasyWindowSwap()<CR>')

-- telescope.nvim
noremap('n', '<tab>t', ':Telescope<CR>')
noremap('n', '<tab>c', ':Telescope commands<CR>')
noremap('n', '<CR><CR>', ':Telescope find_files hidden=true<CR>')
noremap('n', '<CR>b', ':Telescope buffers<CR>')
noremap('n', '<space><space>', ':Telescope grep_string<CR>')
noremap('n', '<space>r', ':Telescope live_grep<CR>')
noremap('n', '<space>/', ':Telescope current_buffer_fuzzy_find<CR>')

vim.keymap.set({'n', 'v'}, '<cr><tab>', function()
    local text = selection.get_smart_selection()
    require'telescope.builtin'.find_files({search_file = text, hidden = true})
end)
vim.keymap.set({'n', 'v'}, '<space><tab>', function()
    local text = selection.get_smart_selection()
    require'telescope.builtin'.grep_string({search = text})
end)

-- fzf
noremap('n', '<space><leader><space>', ':Rg<CR>')
noremap('n', '<space><leader><tab>', ':Rg \\b<C-R><C-W>\\b<CR>')
noremap('v', '<space><leader><tab>', '"wy:Rg <C-R>w<CR>')
noremap('n', '<space><leader>/', ':Lines<CR>')

map('i', '<c-\\><c-k>', '<plug>(fzf-complete-word)')
map('i', '<c-\\><c-f>', '<plug>(fzf-complete-path)')
map('i', '<c-\\><c-l>', '<plug>(fzf-complete-line)')

-- nerdtree
noremap('n', '<leader>nE', ':NERDTree<CR>')
noremap('n', '<leader>ne', ':NERDTreeFocus<CR>')
noremap('n', '<leader>nf', ':NERDTreeFind<CR>')
noremap('n', '<leader>nc', ':NERDTreeClose<CR>')

-- emmet-vim
map('n', '<leader>cts', 'va"<esc>`<BcwclassName<esc>f"lcs"{lsstyles.<esc>WX')
