#!/bin/bash
set -e

COMMAND="PlenaryBustedDirectory lua/ {}"
if [[ -n "$1" ]]; then
    COMMAND="PlenaryBustedFile $1"
fi;

nvim --headless -c "$COMMAND" && echo "Tests - OK" || { echo "Tests - FAILED"; exit 1; }

# check formatting
nvim -u NONE --headless -c 'lua require"utils.formatter".check_and_exit()'
