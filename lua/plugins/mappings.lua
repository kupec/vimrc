local mappings = require'utils.mappings'
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
noremap('n', '<space><tab>', ':Telescope grep_string<CR>')
noremap('n', '<space><space>', ':Telescope live_grep<CR>')

-- fzf
noremap('v', '<CR><tab>', '"wy:FZF -q <C-R>w<CR>')
noremap('n', '<space><leader><space>', ':Rg<CR>')
noremap('n', '<space><leader><tab>', ':Rg \\b<C-R><C-W>\\b<CR>')
noremap('v', '<space><leader><tab>', '"wy:Rg <C-R>w<CR>')
noremap('n', '<space>/', ':Lines<CR>')

map('i', '<leader><c-k>', '<plug>(fzf-complete-word)')
map('i', '<leader><c-f>', '<plug>(fzf-complete-path)')
map('i', '<leader><c-l>', '<plug>(fzf-complete-line)')

-- nerdtree
noremap('n', '<leader>nE', ':NERDTree<CR>')
noremap('n', '<leader>ne', ':NERDTreeFocus<CR>')
noremap('n', '<leader>nf', ':NERDTreeFind<CR>')
noremap('n', '<leader>nc', ':NERDTreeClose<CR>')

-- ale
noremap('n', ']l', ':ALENext<CR>')
noremap('n', '[l', ':ALEPrevious<CR>')
noremap('n', '<leader>ll', ':ALEHover<CR>')
noremap('n', '<leader>ld', ':ALEDetail<CR><C-W>J')

-- emmet-vim
map('n', '<leader>cts', 'va"<esc>`<BcwclassName<esc>f"lcs"{lsstyles.<esc>WX')
