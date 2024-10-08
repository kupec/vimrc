#!/bin/bash
set -e

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

### USAGE
#
# env-s:
#   UPDATE=1 - force update pip packages, default - only check that some version of package is installed
###

# TODO: use `uname -o` to determine OS
# TODO: add package manager checker

function has-executable {
    which $1 >/dev/null 2>&1;
}

function is-ubuntu {
    has-executable apt-get;
}

function is-macos {
    has-executable brew;
}

function is-windows {
    has-executable scoop;
}

function run-python {
    if is-windows; then
	{
		echo -n "$PYTHON3";
		for arg in "$@"; do
			echo -n " \"$arg\""
		done;
		echo;
	} | powershell -command -
    else
        "$PYTHON3" "$@"
    fi;
}

function use-python-venv {
    if [[ ! -d venv ]]; then
        run-python -m venv "$SCRIPT_DIR/venv"
    fi;

    PYTHON3="$SCRIPT_DIR/venv/bin/python"

    if ! run-python -m pip --version >/dev/null; then
        echo "Cannot find pip in venv. Please remove venv and rerun script"
        exit 1;
    fi;
}

function pip-install {
    if [[ -n "$UPDATE" ]]; then
        NOT_INSTALLED_PACKAGES=("$@")
    else
        if [[ -z "$PIP_LIST" ]]; then
            PIP_LIST="$(run-python -m pip list 2>/dev/null)"
        fi;

        NOT_INSTALLED_PACKAGES=()
        for package; do
            if ! echo "$PIP_LIST" | grep "$package" >/dev/null; then
                NOT_INSTALLED_PACKAGES+=("$package")
            fi;
        done;
    fi;

    if [[ ${#NOT_INSTALLED_PACKAGES[@]} -gt 0 ]]; then
        echo "Installing python packages: ${NOT_INSTALLED_PACKAGES[@]}"
        run-python -m pip install "${NOT_INSTALLED_PACKAGES[@]}" ${UPDATE:+--upgrade}
    else
        echo "All python packages are installed already"
    fi;
}

function check-package-installed {
    if is-ubuntu; then
        dpkg-query -s "$1" >/dev/null 2>&1;
    elif is-macos; then
        if [[ -z "$BREW_LIST" ]]; then
            BREW_LIST="$(brew list)"
        fi;

        echo $BREW_LIST | grep "$1" >/dev/null;
    elif is-windows; then
        if [[ -z "$SCOOP_LIST" ]]; then
            SCOOP_LIST="$(echo '(scoop export | ConvertFrom-Json).apps | ForEach-Object {$_.Name}' | powershell -command -)"
        fi;

        echo $SCOOP_LIST | grep "$1" >/dev/null;
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
        elif is-windows; then
            scoop install "$@"
        fi;
    else
        return 1
    fi;
}

echo "Installing system dependencies"

PACKAGES=(wget ripgrep watchman)
# 1. git bash on windows already has git + curl
# 2. windows do not have xsel
if ! is-windows; then
    PACKAGES+=(git curl xsel)
fi

# check if npm installed from other sources first (download manually, for example)
if ! has-executable npm; then
    if is-ubuntu; then
        PACKAGES+=(npm)
    elif is-macos; then
        PACKAGES+=(node)
    elif is-windows; then
        PACKAGES+=(nodejs)
    fi;
fi;

# python
PYTHON3=python3

if is-ubuntu; then
    PACKAGES+=(python3 python3-pip python3-venv)
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

use-python-venv
# Install neovim python modules + plugin modules
pip-install pynvim flake8 autopep8 isort jedi requests

NVIM=nvim
if is-ubuntu; then
    run-python -c '
from python.download_nvim import download_linux_appimage
download_linux_appimage()
    '

    # Install neovim gui wrapper
    if [[ ! -d neovim-gnome-terminal ]]; then
        echo "Installing neovim UI"
        (
        git clone https://github.com/fmoralesc/neovim-gnome-terminal-wrapper.git neovim-gnome-terminal;
        cd neovim-gnome-terminal;
        sed -i 's|Exec=.*|Exec=bash -c "source ~/.bashrc; nvim-wrapper %F"|' neovim.desktop
        sudo cp nvim-wrapper /usr/bin/nvim-wrapper;
        sudo cp neovim.desktop /usr/share/applications/neovim.desktop;
        sudo cp neovim.svg /usr/share/icons/neovim.svg;
        )
    fi;
elif is-macos; then
    packages-install neovim || echo "neovim package is up to date"
elif is-windows; then
    packages-install neovim || echo "neovim package is up to date"
fi

run-python -c 'from python.download_lua_format import download; download()'

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
