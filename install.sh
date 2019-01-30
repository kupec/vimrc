#!/bin/bash
set -e

function npm-install {
	if ! which "$1" >/dev/null; then
		npm i -g "$1"
	fi;
}

ROOTDIR="~/.vim"
BUNDLEDIR="$ROOTDIR/bundle"

cat > ~/.vimrc <<EOF
source $ROOTDIR/vimrc
EOF

if [[ -d "$BUNDLEDIR/Vundle.vim" ]]; then
	git clone https://github.com/VundleVim/Vundle.vim.git "$BUNDLEDIR/Vundle.vim"
fi;

if ! which npm >/dev/null; then
	echo "[error]: Please install npm" >&2
	exit 1;
fi;

# vim-livedown (markdown live)
npm-install livedown

# vim-prettier
npm-install prettier

vim +PluginInstall +qall
