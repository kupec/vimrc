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
		if ! dpkg-query -s $x >/dev/null; then
			NEED_INSTALL=yes
			break
		fi;
	done;

	if [[ $NEED_INSTALL == "yes" ]]; then
		sudo apt install "$@" -y
	fi;
}

ROOTDIR="$HOME/.vim"
BUNDLEDIR="$ROOTDIR/bundle"
NVIMDIR="$HOME/.config/nvim"
BINDIR="$HOME/.local/bin"
NVIM_APPIMAGE_URL="https://github.com/neovim/neovim/releases/download/v0.3.8/nvim.appimage"

cat > $HOME/.vimrc <<EOF
source $ROOTDIR/vimrc
EOF

mkdir -p "$NVIMDIR"
cp "$ROOTDIR/init.vim" "$NVIMDIR"

if ! which apt >/dev/null; then
	echo "[error]: No apt. Script works for ubuntu only" >&2
	exit 1;
fi;

sudo apt update
package-install git
which npm || package-install npm

if [[ ! -d "$BUNDLEDIR/Vundle.vim" ]]; then
	git clone https://github.com/VundleVim/Vundle.vim.git "$BUNDLEDIR/Vundle.vim"
fi;

# vim-livedown (markdown live)
npm-install livedown

# vim-prettier
npm-install prettier

# ag (fzf)
package-install silversearcher-ag

# Denite.nvim
package-install python3 python3-pip

# Install neovim
mkdir -p "$BINDIR"
if [[ ! -f "$BINDIR/nvim.appimage" ]]; then
  (
  cd "$BINDIR";
  wget "$NVIM_APPIMAGE_URL" -O nvim;
  chmod +x nvim
  )
fi;

if [[ ! -d neovim-gnome-terminal ]]; then
  (
  git clone https://github.com/fmoralesc/neovim-gnome-terminal-wrapper.git neovim-gnome-terminal;
  cd neovim-gnome-terminal;
  sudo cp nvim-wrapper /usr/bin/nvim-wrapper;
  sudo cp neovim.desktop /usr/share/applications/neovim.desktop;
  sudo cp neovim.svg /usr/share/icons/neovim.svg;
  )
fi;

nvim +PluginInstall +qall
