#!/bin/bash

sudo apt update
sudo apt install -y neovim git ripgrep fd

git clone https://github.com/brunocosta1/dotfiles.git ~/.dotfiles

ln -s ~/.dotfiles/.config/nvim ~/.config/nvim
