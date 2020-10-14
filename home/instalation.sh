#!/usr/bin/bash


# Update repositories

sudo apt update


# Installing the core programs with apt

sudo apt install fonts-powerline i3 fzf fonts-inconsolata xterm rofi vim git build-essential tmux zsh

# Installing other programs 

sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


