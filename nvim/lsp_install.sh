#!/bin/bash

print_err() {
    installer=$1
    lsnames=("$@")
    lsnames=("${lsnames[@]:1}")
    echo "$installer is not installed. Following language servers will be" \
         "skipped"
    for lsname in ${lsnames[@]}; do
        echo "    * $lsname"
    done
    echo
}

npm_ls=(pyright)
if ! command -v npm --version &> /dev/null; then
    print_err "npm" "${npm_ls[@]}"
else
    sudo npm install -g pyright
fi

cargo_ls=(texlab)
if ! command -v cargo --version &> /dev/null; then
    print_err "cargo" "${cargo_ls[@]}"
else
    cargo install texlab
fi

rustup_ls=("rls" "rust-analysis" "rust-src")
if ! command -v rustup --version &> /dev/null; then
    print_err "rustup" "${rustup_ls[@]}"
else
    rustup update
    rustup component add rls rust-analysis rust-src
fi

sudo apt install clangd
