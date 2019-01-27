#!/bin/bash

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

cat > ~/.vimrc <<EOF
source ~/.vim/vimrc
EOF

