#!/bin/bash

set -e  # exits script at first command failure if any

if [[ -z $(command -v stow) ]]; then
    echo "Error: the program 'stow' is required for setup"
    echo "Please install it then execute this script"
    exit 1;
fi

for dir in $(find . -maxdepth 1 -mindepth 1 -type d | sed 's:^\./::'); do
    stow --ignore "README.md" --ignore "install.sh" ${dir}
    if [[ -f "$dir/install.sh" ]]; then
        echo "Executing install script for $dir"
        . "$dir/install.sh"
    fi
done
