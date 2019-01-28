#!/bin/bash

cat > ~/.vimrc <<EOF
source ~/.vim/vimrc
EOF

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# vim-livedown (markdown live)
npm i -g livedown

# vim-prettier
npm i -g prettier

vim +PluginInstall +qall
