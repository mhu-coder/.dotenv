#!/bin/bash

zsh_dir=$ZSH_CUSTOM

if [[ ! -d "$zsh_dir" ]]; then
    echo "Error: $zsh_dir does not exist. Are you sure it is correct?"
    exit 1;
fi

declare -A packages
packages=(
    ['zsh-autosuggestions']='zsh-users/zsh-autosuggestions'
)

for package in "${!packages[@]}"; do
    install_dir="$zsh_dir/plugins/${package}"
    if [[ ! -d "$install_dir" ]]; then
        echo "Installing $package into $install_dir"
        git clone https://github.com/${packages[$package]} \
            "$install_dir" || exit 1;
        echo "Successfully installed $package"
        echo
    else
        echo "$install_dir already exists. Skipping"
    fi
done

