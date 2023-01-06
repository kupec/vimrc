import os
from pathlib import Path
import requests
from typing import Callable, TypeVar, Optional, List

from download_file import fetch_file

T = TypeVar('T')


def find(array: List[T], condition: Callable[..., bool]) -> Optional[T]:
    for item in array:
        if condition(item):
            return item
    return None


def get_appimage_dir() -> str:
    home_dir = os.getenv('HOME')
    return f'{home_dir}/.local/bin'


def get_exe_path() -> str:
    return f'{get_appimage_dir()}/nvim'


def get_version_file() -> str:
    return f'{get_appimage_dir()}/.nvim.version'


def get_current_version() -> str:
    try:
        return Path(get_version_file()).read_text()
    except Exception:
        return ''


def save_current_version(version: str):
    return Path(get_version_file()).write_text(version)


def fetch_last_version() -> str:
    resp = requests.get('https://api.github.com/repos/neovim/neovim/releases')
    releases = resp.json()

    stable_release = find(releases, lambda r: r['tag_name'] == 'stable')
    if not stable_release:
        raise RuntimeError('No stable release found')

    commit = stable_release['target_commitish']
    specific_release = find(
        releases,
        lambda r: r != stable_release and r['target_commitish'] == commit
    )
    if not specific_release:
        raise RuntimeError('Cannot found stable release version')

    return specific_release['tag_name']


def fetch_linux_appimage_file():
    fetch_file(
        url='https://github.com/neovim/neovim/releases/download/stable/nvim.appimage',
        path=get_exe_path(),
        mode=0o755,
    )


def download_linux_appimage():
    current_version = get_current_version()
    last_version = fetch_last_version()
    if current_version == last_version:
        print('Installed neovim version is already latest')
        return

    print(f'Downloading new neovim version - {last_version}')
    fetch_linux_appimage_file()
    save_current_version(last_version)
