vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer itself
    use 'wbthomason/packer.nvim'

    -- sudo
    use 'lambdalisue/suda.vim'

    -- format
    use 'editorconfig/editorconfig-vim'
    use {
        'prettier/vim-prettier',
        run = 'npm i -g prettier',
    }
    use 'frazrepo/vim-rainbow'

    -- format js
    use 'pangloss/vim-javascript'
    use 'maxmellon/vim-jsx-pretty'
    use 'leafgarland/typescript-vim'
    use 'ianks/vim-tsx'

    -- format go
    use 'fatih/vim-go'

    -- format python
    use 'vim-python/python-syntax'

    -- movement
    use 'easymotion/vim-easymotion'

    -- editing
    use 'mattn/emmet-vim'
    use 'tpope/vim-surround'
    use 'tpope/vim-abolish'
    use 'arthurxavierx/vim-caser'
    use {
        'heavenshell/vim-jsdoc',
        ft = {'javascript', 'javascript.jsx','typescript'}, 
        run = 'make install',
    }

    -- autocomplete
    use 'wellle/tmux-complete.vim'
    use {
        'neoclide/coc.nvim',
        branch = 'release',
    }

    -- search
    use {
        'junegunn/fzf',
        run = function() vim.fn['fzf#install']() end
    }
    use 'junegunn/fzf.vim'
    use {
        'nvim-telescope/telescope.nvim',
        requires = { {'nvim-lua/plenary.nvim'} },
    }
    use {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make',
    }

    -- file manager
    use 'scrooloose/nerdtree'

    -- markdown preview
    use {
        'shime/vim-livedown',
        run = 'sudo npm i -g livedown',
    }

    -- git plugin
    use 'tpope/vim-fugitive'
    use 'airblade/vim-gitgutter'

    -- linter
    use 'w0rp/ale'

    -- color scheme
    use 'NLKNguyen/papercolor-theme'
    use 'vim-airline/vim-airline'
    use 'vim-airline/vim-airline-themes'

    -- highlight
    use 'lfv89/vim-interestingwords'

    -- windows
    use 'wesQ3/vim-windowswap'

    -- snippets
    use 'SirVer/ultisnips'
    use 'honza/vim-snippets'

    -- terminal
    use 'kassio/neoterm'
end)
