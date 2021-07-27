#!/bin/bash
set -ex

function is-ubuntu {
	which apt-get;
}

function is-macos {
	which port;
}

function npm-install {
	if ! which "$1" >/dev/null; then
		sudo npm i -g "$1"
	fi;
}

function pip-install {
	if ! which "$1" >/dev/null; then
		sudo python3 -m pip install --user "$1"
	fi;
}

function package-install {
	if is-ubuntu; then
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
	elif is-macos; then
		sudo port install "$@"
	fi;
	
}

ROOTDIR="$HOME/.vim"
NVIM_AUTOLOAD_PLUGIN_DIR="$HOME/.local/share/nvim/site/autoload"
NVIM_PLUG_VIM="$NVIM_AUTOLOAD_PLUGIN_DIR/plug.vim"
NVIMDIR="$HOME/.config/nvim"

NVIM=nvim
if is-ubuntu; then
	NVIM_APPIMAGE_URL="https://github.com/neovim/neovim/releases/download/stable/nvim.appimage"
	NVIM_APPIMAGE_DIR="$HOME/.local/bin"
	NVIM="$NVIM_APPIMAGE_DIR/nvim"
fi;

mkdir -p "$NVIMDIR"
cp "$ROOTDIR/init.vim" "$NVIMDIR"

if is-ubuntu; then
	sudo apt update
fi;

PYTHON3=python3
PIP3=python3-pip
if is-macos; then
    PYTHON3=python39
    PIP3=py39-pip
fi;

package-install git curl xsel $PYTHON3 $PIP3
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

# fd (fzf)
if is-ubuntu; then
	FD_PACKAGE=fd-find
else
	FD_PACKAGE=fd
fi;

package-install "$FD_PACKAGE" ripgrep watchman

# Install neovim python modules + plugin modules
pip-install pynvim flake8 autopep8 isort jedi

if is-ubuntu; then
	(
	cd "$NVIM_APPIMAGE_DIR";
	wget "$NVIM_APPIMAGE_URL" -O nvim;
	chmod +x nvim;
	)

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
fi;

"$NVIM" +PlugInstall +qall
"$NVIM" -c 'CocInstall -sync coc-tsserver coc-css coc-json coc-html coc-python|q'

