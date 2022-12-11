#!/bin/bash
set -e

function is-ubuntu {
    which apt-get >/dev/null;
}

function is-macos {
    which brew >/dev/null;
}

function pip-install {
    if [[ -z "$PIP_LIST" ]]; then
        PIP_LIST="$("$PYTHON3" -m pip list 2>/dev/null)"
    fi;

    NOT_INSTALLED_PACKAGES=()
    for package; do
        if ! echo "$PIP_LIST" | grep "$package" >/dev/null; then
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

function check-package-installed {
    if is-ubuntu; then
        dpkg-query -s "$1" >/dev/null;
    elif is-macos; then
        if [[ -z "$BREW_LIST" ]]; then
            BREW_LIST="$(brew list)"
        fi;

        echo $BREW_LIST | grep "$1" >/dev/null;
    fi;
}

function packages-install {
    local NEED_INSTALL=""
    for package; do
        if ! check-package-installed "$package"; then
            NEED_INSTALL=yes
            break
        fi;
    done;

    if [[ $NEED_INSTALL == "yes" ]]; then
        if is-ubuntu; then
            sudo apt update
            sudo apt install "$@" -y
        elif is-macos; then
            brew install "$@"
        fi;
    else
        return 1
    fi;
}

echo "Installing system dependencies"

PACKAGES=(git curl wget xsel ripgrep watchman)

# check if npm installed from other sources first (download manually, for example)
which npm >/dev/null || PACKAGES+=(npm)

# python
PYTHON3=python3
if is-ubuntu; then
    PACKAGES+=(python3 python3-pip)
else
    PACKAGES+=(python)
fi;

# fd (fzf)
if is-ubuntu; then
    PACKAGES+=(fd-find)
else
    PACKAGES+=(fd)
fi;

packages-install "${PACKAGES[@]}" || echo "All system packages are installed already"


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
    packages-install neovim || echo "neovim package is up to date"

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
echo "Done"
