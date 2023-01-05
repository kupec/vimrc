#!/bin/bash

nvim -u NONE --headless -c 'lua require"utils.formatter".format_and_exit()'
