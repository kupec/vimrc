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
NVIM_AUTOLOAD_PLUGIN_DIR="$HOME/.local/share/nvim/site/autoload"
NVIM_PLUG_VIM="$NVIM_AUTOLOAD_PLUGIN_DIR/plug.vim"
NVIMDIR="$HOME/.config/nvim"

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
package-install git curl xsel
# check if npm installed from other sources first (download manually, for example)
which npm || package-install npm

if [[ ! -f "$NVIM_PLUG_VIM" ]]; then
    curl -fLo $NVIM_PLUG_VIM --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi;

# add coc extensions
(
mkdir -p "$HOME/.config/coc/extensions";
cd "$HOME/.config/coc/extensions";
npm install;
)

# vim-livedown (markdown live)
npm-install livedown

# vim-prettier
npm-install prettier

# ag (fzf)
package-install silversearcher-ag

package-install python3 python3-pip

# Install neovim
pip3 install neovim

# Install neovim gui wrapper
if [[ ! -d neovim-gnome-terminal ]]; then
  (
  git clone https://github.com/fmoralesc/neovim-gnome-terminal-wrapper.git neovim-gnome-terminal;
  cd neovim-gnome-terminal;
  sudo cp nvim-wrapper /usr/bin/nvim-wrapper;
  sudo cp neovim.desktop /usr/share/applications/neovim.desktop;
  sudo cp neovim.svg /usr/share/icons/neovim.svg;
  )
fi;

nvim +PlugInstall +qall
