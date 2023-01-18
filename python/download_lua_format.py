import functools
import json
from pathlib import Path
import platform
import requests
import subprocess

from .download_file import fetch_file


DOWNLOAD_BASE_URL = 'https://raw.githubusercontent.com/Koihik/vscode-lua-format/master/bin'
OS_VARIANTS = {
    'Linux': 'linux/lua-format',
    'Darwin': 'darwin/lua-format',
    'Windows': 'win32/lua-format.exe',
}


@functools.lru_cache()
def get_nvim_stdpath(key: str) -> Path:
    process = subprocess.run(
        [
            'nvim',
            '-u',
            'NONE',
            '--headless',
            '-c',
            f'echo stdpath("{key}") | quit',
        ],
        capture_output=True,
    )
    dir = process.stderr.strip().decode()
    return Path(dir)


def get_cache_path() -> Path:
    return get_nvim_stdpath('cache') / 'download.json'


def get_bin_path() -> Path:
    return get_nvim_stdpath('data') / 'bin'


def read_cache() -> dict:
    try:
        json_data = get_cache_path().read_text()
        return json.loads(json_data)
    except FileNotFoundError:
        return {}


def write_cache(value: dict):
    json_data = json.dumps(value)
    return get_cache_path().write_text(json_data)


def get_exe_url() -> str:
    return DOWNLOAD_BASE_URL + '/' + OS_VARIANTS[platform.system()]


def get_exe_path() -> Path:
    return get_bin_path() / 'lua-format'


def fetch_exe_etag() -> str:
    resp = requests.head(get_exe_url())
    return resp.headers['etag']


def fetch_exe_file():
    fetch_file(
        url=get_exe_url(),
        path=str(get_exe_path()),
        mode=0o755,
    )


def download():
    download_cache = read_cache()

    etag = fetch_exe_etag()
    current_etag = download_cache.get('lua_format')
    if current_etag == etag:
        print('Installed lua-format is already latest')
        return

    print('Downloading new lua-format version')
    fetch_exe_file()

    download_cache['lua_format'] = etag
    write_cache(download_cache)
