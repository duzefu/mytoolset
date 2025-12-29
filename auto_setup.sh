#!/bin/bash

cp -rf ./tools ~/
cp -f .bashrc ~/
source ~/.bashrc

if ! command -v fdfind &> /dev/null; then
    echo "fdfind could not be found, installing..."
    sudo apt install -y fd-find
fi

if ! command -v ripgrep &> /dev/null; then
    echo "ripgrep could not be found, installing..."
    sudo apt install -y ripgrep
fi
