import os
from pathlib import Path
import requests
import sys


def fetch_file(url: str, path: str, mode: int = 0o644):
    os.makedirs(Path(path).parent, exist_ok=True)

    resp = requests.get(url, stream=True)
    with open(path, 'wb') as fd:
        total_fetched = 0
        total_size = int(resp.headers['content-length'])

        for chunk in resp.iter_content(chunk_size=4096):
            fd.write(chunk)

            total_fetched += len(chunk)
            percent = 100 * total_fetched / total_size
            sys.stdout.write(f'\r\tdownloading {percent:.1f}%')
    os.chmod(path, mode)
    sys.stdout.write('\r')
