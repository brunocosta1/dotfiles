#!/bin/bash

# --- Configurações ---
DOTFILES_REPO="https://github.com/brunocosta1/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"
FONT_DIR="$HOME/.local/share/fonts"

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 Iniciando o setup completo do ambiente...${NC}"

# 1. Dependências do Sistema & PHP
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo -e "${GREEN}🍎 Instalando pacotes macOS via Homebrew...${NC}"
  brew install neovim tmux zsh git curl alacritty stow ripgrep fd fzf coreutils openssl readline libxml2 curl
else
  echo -e "${GREEN}🐧 Instalando pacotes Linux...${NC}"
  sudo apt update
  # Dependências essenciais + as necessárias para compilar PHP no asdf
  sudo apt install -y nvim tmux zsh git curl alacritty stow ripgrep fd-find fzf \
    build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
    libsqlite3-dev libxml2-dev libcurl4-openssl-dev libonig-dev libzip-dev
fi

# 2. Dotfiles
if [ ! -d "$DOTFILES_DIR" ]; then
  echo -e "${GREEN}📦 Clonando seus dotfiles...${NC}"
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

# 3. JetBrainsMono Nerd Font
if [ ! -d "$FONT_DIR/JetBrainsMono" ]; then
  echo -e "${GREEN}🔡 Instalando JetBrainsMono Nerd Font...${NC}"
  mkdir -p "$FONT_DIR"
  curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip -o /tmp/jb.zip
  unzip /tmp/jb.zip -d "$FONT_DIR/JetBrainsMono"
  [ -x "$(command -v fc-cache)" ] && fc-cache -fv
fi

# 4. Oh-My-Zsh e Plugins
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo -e "${GREEN}🐚 Instalando Oh-My-Zsh...${NC}"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 5. ASDF & PHP
if [ ! -d "$HOME/.asdf" ]; then
  echo -e "${GREEN}🛠️ Instalando asdf e plugin PHP...${NC}"
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
  # Carregar asdf temporariamente para este script
  . "$HOME/.asdf/asdf.sh"
  asdf plugin add php
fi

# 6. Tmux Plugin Manager (TPM)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  echo -e "${GREEN}🪟 Instalando TPM (Tmux Plugin Manager)...${NC}"
  mkdir -p ~/.tmux/plugins
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# 7. Symlinks (Vinculando seu repo ao sistema)
echo -e "${GREEN}🔗 Criando links simbólicos...${NC}"
mkdir -p ~/.config
ln -sfn "$DOTFILES_DIR/nvim" ~/.config/nvim
ln -sfn "$DOTFILES_DIR/alacritty" ~/.config/alacritty
ln -sfn "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sfn "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"

echo -e "${BLUE}--- SETUP FINALIZADO ---${NC}"
echo -e "1. Abra o Neovim para o LazyVim instalar os plugins automaticamente."
echo -e "2. No Tmux, pressione 'prefix + I' para instalar os plugins do TPM."
echo -e "3. Rode 'asdf install php latest' para finalizar a instalação do PHP."
