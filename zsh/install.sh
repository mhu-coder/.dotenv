#!/bin/bash

if ! command -v zsh --version &> /dev/null; then
    echo "zsh is not installed. Please install then execute this script"
    exit 1
fi

if [[ ! -f "$HOME/.zshrc" ]]; then
    echo ".zshrc not found in $HOME. Aborting"
    exit 1
fi

if [[ ! -d "$HOME/oh-my-zsh" ]]; then
    echo "Installing oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

source $HOME/.zshrc

zsh_dir=$ZSH_CUSTOM

mkdir -p $zsh_dir

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

