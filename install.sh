#!/bin/bash
set -e

function is-ubuntu {
    which apt-get >/dev/null;
}

function is-macos {
    which brew >/dev/null;
}

function pip-install {
    NOT_INSTALLED_PACKAGES=()
    for package; do
        if ! "$PYTHON3" -m pip show "$package" >/dev/null; then
            NOT_INSTALLED_PACKAGES+=("$package")
        fi;
    done;

    if [[ ${#NOT_INSTALLED_PACKAGES[@]} -gt 0 ]]; then
        echo "Installing python packages: ${NOT_INSTALLED_PACKAGES[@]}"
        "$PYTHON3" -m pip install --user "${NOT_INSTALLED_PACKAGES[@]}"
    else
        echo "All python packages are installed already"
    fi;
}

function packages-install {
    if is-ubuntu; then
        local NEED_INSTALL=""
        for package; do
            if ! dpkg-query -s "$package" >/dev/null; then
                NEED_INSTALL=yes
                break
            fi;
        done;

        if [[ $NEED_INSTALL == "yes" ]]; then
            sudo apt update
            sudo apt install "$@" -y
        else
            echo "All system packages are installed already"
        fi;
    elif is-macos; then
        brew install "$@"
    fi;
    
}

PYTHON3=python3
PIP3=python3-pip
if is-macos; then
    PYTHON3=python39
    PIP3=py39-pip
fi;

PACKAGES=(git curl xsel "$PYTHON3" "$PIP3")
# check if npm installed from other sources first (download manually, for example)
which npm >/dev/null || PACKAGES+=('npm')

# fd (fzf)
if is-ubuntu; then
    FD_PACKAGE=fd-find
else
    FD_PACKAGE=fd
fi;

PACKAGES+=("$FD_PACKAGE" ripgrep watchman)

packages-install "${PACKAGES[@]}"

# Install neovim python modules + plugin modules
pip-install pynvim flake8 autopep8 isort jedi

NVIM=nvim
if is-ubuntu; then
    NVIM_APPIMAGE_DIR="$HOME/.local/bin"
    NVIM="$NVIM_APPIMAGE_DIR/nvim"
    NVIM_VERSION_FILE="$NVIM_APPIMAGE_DIR/.nvim.version"
    NVIM_APPIMAGE_DESC_URL="https://api.github.com/repos/neovim/neovim/releases/latest"
    NVIM_APPIMAGE_URL="https://github.com/neovim/neovim/releases/download/stable/nvim.appimage"

    NVIM_NEW_VERSION=$(curl -s "$NVIM_APPIMAGE_DESC_URL" \
        | "$PYTHON3" -c 'import sys; import json; print(json.load(sys.stdin)["html_url"])')
    touch "$NVIM_VERSION_FILE"
    NVIM_CUR_VERSION=$(<"$NVIM_VERSION_FILE")

    if [[ $NVIM_NEW_VERSION != $NVIM_CUR_VERSION ]]; then
        echo "Downloading new version of neovim"
        wget "$NVIM_APPIMAGE_URL" -O "$NVIM"
        chmod +x "$NVIM"

        echo $NVIM_NEW_VERSION > $NVIM_VERSION_FILE
    else
        echo "Installed neovim version is already latest"
    fi;

    # Install neovim gui wrapper
    if [[ ! -d neovim-gnome-terminal ]]; then
        echo "Installing neovim UI"
        (
        git clone https://github.com/fmoralesc/neovim-gnome-terminal-wrapper.git neovim-gnome-terminal;
        cd neovim-gnome-terminal;
        sudo cp nvim-wrapper /usr/bin/nvim-wrapper;
        sudo cp neovim.desktop /usr/share/applications/neovim.desktop;
        sudo cp neovim.svg /usr/share/icons/neovim.svg;
        )
    fi;
fi;

if is-macos; then
    packages-install neovim
fi

NVIM_DATA_DIR=$("$NVIM" -u NONE --headless -c 'echo stdpath("data") | quitall' 2>&1)
NVIM_PACKER="$NVIM_DATA_DIR/site/pack/packer/start/packer.nvim"

if [[ ! -d "$NVIM_PACKER" ]]; then
    echo "Installing nvim packer (plugin manager)"
    git clone --depth 1 \
        https://github.com/wbthomason/packer.nvim \
        "$NVIM_PACKER"
else 
    echo "Plugin manager is already installed"
fi;

echo "Installing/updating nvim plugins"
NVIM_INSTALL_PLUGIN_MODE=yes "$NVIM" --headless; echo
