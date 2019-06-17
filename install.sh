#!/bin/bash
set -e

function npm-install {
	if ! which "$1" >/dev/null; then
		sudo npm i -g "$1"
	fi;
}

function package-install {
	local NEED_INSTALL=""
	for x; do
		if ! dpkg-query -s $x; then
			NEED_INSTALL=yes
			break
		fi;
	done;

	if [[ $NEED_INSTALL == "yes" ]]; then
		sudo apt install "$@" -y
	fi;
}

ROOTDIR="~/.vim"
BUNDLEDIR="$ROOTDIR/bundle"

cat > ~/.vimrc <<EOF
source $ROOTDIR/vimrc
EOF

if ! which apt >/dev/null; then
	echo "[error]: No apt. Script works for ubuntu only" >&2
	exit 1;
fi;

sudo apt update
package-install git
[[ which npm ]] || package-install npm

if [[ ! -d "$BUNDLEDIR/Vundle.vim" ]]; then
	git clone https://github.com/VundleVim/Vundle.vim.git "$BUNDLEDIR/Vundle.vim"
fi;

# vim-livedown (markdown live)
npm-install livedown

# vim-prettier
npm-install prettier

# ag (fzf)
package-install silversearcher-ag

vim +PluginInstall +qall
