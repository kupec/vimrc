#!/bin/bash
set -ex

function is-ubuntu {
	which apt-get;
}

function is-macos {
	which port;
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

# add coc extensions
(
mkdir -p "$HOME/.config/coc/extensions";
cd "$HOME/.config/coc/extensions";
npm install;
)

# fd (fzf)
if is-ubuntu; then
	FD_PACKAGE=fd-find
else
	FD_PACKAGE=fd
fi;

package-install "$FD_PACKAGE" ripgrep watchman

# Install neovim python modules + plugin modules
pip-install pynvim flake8 autopep8 isort jedi

NVIM=nvim
if is-ubuntu; then
    NVIM_APPIMAGE_DIR="$HOME/.local/bin"
    NVIM="$NVIM_APPIMAGE_DIR/nvim"
    NVIM_VERSION_FILE="$NVIM_APPIMAGE_DIR/.nvim.version"
    NVIM_APPIMAGE_DESC_URL="https://api.github.com/repos/neovim/neovim/releases/latest"
    NVIM_APPIMAGE_URL="https://github.com/neovim/neovim/releases/download/stable/nvim.appimage"

    NVIM_NEW_VERSION=$(curl "$NVIM_APPIMAGE_DESC_URL" \
        | "$PYTHON3" -c 'import sys; import json; print(json.load(sys.stdin)["html_url"])')
    touch "$NVIM_VERSION_FILE"
    NVIM_CUR_VERSION=$(<"$NVIM_VERSION_FILE")

    if [[ $NVIM_NEW_VERSION != $NVIM_CUR_VERSION ]]; then
        wget "$NVIM_APPIMAGE_URL" -O "$NVIM"
        chmod +x "$NVIM"

        echo $NVIM_NEW_VERSION > $NVIM_VERSION_FILE
    fi;

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

NVIM_DATA_DIR=$("$NVIM" -u NONE --headless -c 'echo stdpath("data") | quitall' 2>&1)
NVIM_PACKER="$NVIM_DATA_DIR/site/pack/packer/start/packer.nvim"

if [[ ! -d "$NVIM_PACKER" ]]; then
    git clone --depth 1 \
        https://github.com/wbthomason/packer.nvim \
        "$NVIM_PACKER"
fi;

NVIM_INSTALL_PLUGIN_MODE=yes "$NVIM" --headless
"$NVIM" --headless -c 'CocInstall -sync coc-tsserver coc-css coc-json coc-html coc-python | quitall'

