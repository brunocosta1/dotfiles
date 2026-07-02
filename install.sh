#!/usr/bin/env bash
#
# install.sh — Setup completo do ambiente para Pop!_OS 22.04 LTS (base Ubuntu jammy)
#
# Instala toda a stack: i3wm + Alacritty + Neovim (LazyVim) + tmux + zsh (pure),
# fontes, ferramentas de CLI e o i3lock-color.
#
# Executa NO LOCAL do próprio repositório (não faz git clone), preservando
# quaisquer alterações não commitadas. Arquivos reais existentes são movidos
# para *.bak antes de criar os links simbólicos.
#
# Uso:  ./install.sh
#
set -euo pipefail

# --- Diretórios ---
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FONT_DIR="$HOME/.local/share/fonts"
LOCAL_BIN="$HOME/.local/bin"

# --- Cores ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

log()   { echo -e "${GREEN}==>${NC} $*"; }
info()  { echo -e "${BLUE}  ->${NC} $*"; }
warn()  { echo -e "${YELLOW}  ! ${NC} $*"; }
err()   { echo -e "${RED}  x ${NC} $*" >&2; }

mkdir -p "$FONT_DIR" "$LOCAL_BIN" "$HOME/.config"

echo -e "${BLUE}🚀 Setup do ambiente (Pop!_OS 22.04) a partir de: ${DOTFILES_DIR}${NC}"

# ---------------------------------------------------------------------------
# 1. Pacotes do sistema (APT)
# ---------------------------------------------------------------------------
log "Instalando pacotes do sistema via APT..."
sudo apt update
sudo apt install -y \
  git curl wget unzip ca-certificates gnupg \
  build-essential pkg-config autoconf bison re2c stow \
  zsh tmux ripgrep fd-find fzf \
  i3 i3blocks rofi feh picom numlockx xss-lock brightnessctl \
  maim xclip gnome-screenshot \
  network-manager-gnome policykit-1-gnome pulseaudio-utils \
  x11-xserver-utils \
  firefox \
  python3 python3-pil fontconfig \
  libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
  libxml2-dev libcurl4-openssl-dev libonig-dev libzip-dev

# ---------------------------------------------------------------------------
# 2. Neovim (binário oficial mais recente)
# ---------------------------------------------------------------------------
if ! command -v nvim >/dev/null 2>&1; then
  log "Instalando Neovim (binário oficial)..."
  NVIM_TMP="$(mktemp -d)"
  # A partir da v0.10.4 o asset mudou de nvim-linux64 -> nvim-linux-x86_64.
  for asset in nvim-linux-x86_64 nvim-linux64; do
    url="https://github.com/neovim/neovim/releases/latest/download/${asset}.tar.gz"
    if curl -fL -o "$NVIM_TMP/nvim.tar.gz" "$url"; then
      info "Baixado: $asset"
      sudo rm -rf "/opt/${asset}"
      sudo tar -C /opt -xzf "$NVIM_TMP/nvim.tar.gz"
      sudo ln -sfn "/opt/${asset}/bin/nvim" /usr/local/bin/nvim
      break
    fi
  done
  rm -rf "$NVIM_TMP"
  command -v nvim >/dev/null 2>&1 && info "Neovim: $(nvim --version | head -1)" || err "Falha ao instalar Neovim"
else
  info "Neovim já instalado: $(nvim --version | head -1)"
fi

# ---------------------------------------------------------------------------
# 3. Nerd Fonts (JetBrainsMono p/ Alacritty, Meslo p/ i3bar/pure)
# ---------------------------------------------------------------------------
NF_VERSION="v3.2.1"
install_nerd_font() {
  local name="$1"
  if [ -d "$FONT_DIR/$name" ]; then
    info "Fonte $name já instalada"
    return
  fi
  log "Instalando Nerd Font: $name..."
  local tmp; tmp="$(mktemp)"
  curl -fL "https://github.com/ryanoasis/nerd-fonts/releases/download/${NF_VERSION}/${name}.zip" -o "$tmp"
  unzip -o -q "$tmp" -d "$FONT_DIR/$name"
  rm -f "$tmp"
}
install_nerd_font "JetBrainsMono"
install_nerd_font "Meslo"
fc-cache -f >/dev/null 2>&1 || true

# ---------------------------------------------------------------------------
# 4. Oh-My-Zsh + plugins + pure prompt
# ---------------------------------------------------------------------------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  log "Instalando Oh-My-Zsh..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  info "Oh-My-Zsh já instalado"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
clone_if_missing() {
  local dest="$1" repo="$2"
  if [ ! -d "$dest" ]; then
    info "Clonando $(basename "$dest")..."
    git clone --depth=1 "$repo" "$dest"
  fi
}
log "Instalando plugins zsh e pure prompt..."
clone_if_missing "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" https://github.com/zsh-users/zsh-syntax-highlighting.git
clone_if_missing "$ZSH_CUSTOM/plugins/zsh-autosuggestions"    https://github.com/zsh-users/zsh-autosuggestions.git
clone_if_missing "$HOME/.zsh/pure"                            https://github.com/sindresorhus/pure.git

# ---------------------------------------------------------------------------
# 5. lsd (não empacotado no 22.04 — instala via .deb do GitHub)
# ---------------------------------------------------------------------------
if ! command -v lsd >/dev/null 2>&1; then
  log "Instalando lsd..."
  LSD_VER="1.1.5"
  ARCH="$(dpkg --print-architecture)"   # amd64 / arm64
  tmp="$(mktemp --suffix=.deb)"
  if curl -fL "https://github.com/lsd-rs/lsd/releases/download/v${LSD_VER}/lsd_${LSD_VER}_${ARCH}.deb" -o "$tmp"; then
    sudo apt install -y "$tmp"
  else
    warn "Não foi possível baixar o .deb do lsd (arch=$ARCH). Instale manualmente."
  fi
  rm -f "$tmp"
else
  info "lsd já instalado"
fi

# ---------------------------------------------------------------------------
# 6. asdf (v0.18 — binário Go) + plugins
# ---------------------------------------------------------------------------
if ! command -v asdf >/dev/null 2>&1 && [ ! -x "$LOCAL_BIN/asdf" ]; then
  log "Instalando asdf (binário Go)..."
  ASDF_VER="v0.18.0"
  ARCH="$(dpkg --print-architecture)"   # amd64 / arm64
  tmp="$(mktemp -d)"
  if curl -fL "https://github.com/asdf-vm/asdf/releases/download/${ASDF_VER}/asdf-${ASDF_VER}-linux-${ARCH}.tar.gz" -o "$tmp/asdf.tar.gz"; then
    tar -C "$tmp" -xzf "$tmp/asdf.tar.gz"
    install -m 0755 "$tmp/asdf" "$LOCAL_BIN/asdf"
    info "asdf instalado em $LOCAL_BIN/asdf"
  else
    warn "Falha ao baixar asdf $ASDF_VER (arch=$ARCH)."
  fi
  rm -rf "$tmp"
else
  info "asdf já instalado"
fi

export ASDF_DATA_DIR="$HOME/.asdf"
export PATH="$LOCAL_BIN:${ASDF_DATA_DIR}/shims:$PATH"
if command -v asdf >/dev/null 2>&1; then
  log "Adicionando plugins do asdf (node, php)..."
  asdf plugin add node 2>/dev/null || true
  asdf plugin add php  2>/dev/null || true
fi

# ---------------------------------------------------------------------------
# 7. Tmux Plugin Manager (TPM)
# ---------------------------------------------------------------------------
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  log "Instalando TPM (Tmux Plugin Manager)..."
  git clone --depth=1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
  info "TPM já instalado"
fi

# ---------------------------------------------------------------------------
# 8. Symlinks (in-place, com backup dos arquivos reais existentes)
# ---------------------------------------------------------------------------
log "Criando links simbólicos..."
mkdir -p "$HOME/.config/i3"

link() {
  local src="$1" dst="$2"
  if [ ! -e "$src" ]; then
    warn "Origem inexistente, pulando: $src"
    return
  fi
  # Já é o link correto? nada a fazer.
  if [ -L "$dst" ] && [ "$(readlink -f "$dst")" = "$(readlink -f "$src")" ]; then
    return
  fi
  # Arquivo/dir real existente -> backup.
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    mv "$dst" "${dst}.bak.$(date +%s)"
    info "Backup: $dst -> ${dst}.bak"
  fi
  ln -sfn "$src" "$dst"
  info "$dst -> $src"
}

link "$DOTFILES_DIR/nvim"          "$HOME/.config/nvim"
link "$DOTFILES_DIR/alacritty"     "$HOME/.config/alacritty"
link "$DOTFILES_DIR/zshrc"         "$HOME/.zshrc"           # arquivo ATIVO (com pure/lsd/asdf)
link "$DOTFILES_DIR/.tmux.conf"    "$HOME/.tmux.conf"
link "$DOTFILES_DIR/picom.conf"    "$HOME/.config/picom.conf"
link "$DOTFILES_DIR/config"        "$HOME/.config/i3/config"
link "$DOTFILES_DIR/i3blocks.conf" "$HOME/.config/i3/i3blocks.conf"
link "$DOTFILES_DIR/lock"          "$HOME/.config/i3/lock"
link "$DOTFILES_DIR/monitors.sh"   "$HOME/.config/i3/monitors.sh"
[ -f "$DOTFILES_DIR/.Xresources" ] && link "$DOTFILES_DIR/.Xresources" "$HOME/.Xresources"

chmod +x "$DOTFILES_DIR/lock" "$DOTFILES_DIR/monitors.sh" \
         "$DOTFILES_DIR/tmux-new-session.sh" 2>/dev/null || true

# ---------------------------------------------------------------------------
# 9. i3lock-color (compilado — usado pelo script ~/.config/i3/lock)
# ---------------------------------------------------------------------------
if ! command -v i3lock >/dev/null 2>&1 || ! i3lock --help 2>&1 | grep -q 'clock'; then
  log "Compilando i3lock-color..."
  sudo apt install -y autoconf gcc make pkg-config libpam0g-dev libcairo2-dev \
    libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev \
    libxcb-image0-dev libxcb-util-dev libxcb-xrm-dev libxcb-randr0-dev libxcb-xinerama0-dev \
    libxkbcommon-dev libxkbcommon-x11-dev libgif-dev
  I3LC_TMP="$(mktemp -d)"
  git clone --depth=1 https://github.com/Raymo111/i3lock-color.git "$I3LC_TMP"
  ( cd "$I3LC_TMP" && autoreconf -i && ./configure --prefix=/usr/local && make -j"$(nproc)" && sudo make install )
  rm -rf "$I3LC_TMP"
else
  info "i3lock-color já disponível"
fi

# ---------------------------------------------------------------------------
# 10. Shell padrão -> zsh
# ---------------------------------------------------------------------------
if [ "${SHELL:-}" != "$(command -v zsh)" ]; then
  log "Definindo zsh como shell padrão..."
  chsh -s "$(command -v zsh)" || warn "chsh falhou — rode manualmente: chsh -s \$(command -v zsh)"
fi

# ---------------------------------------------------------------------------
# Final
# ---------------------------------------------------------------------------
echo -e "${BLUE}--- SETUP FINALIZADO ---${NC}"
cat <<EOF

Próximos passos:
  1. Faça logout/login (ou reinicie) e escolha a sessão "i3" na tela de login.
  2. Abra o Neovim (\`nvim\`) para o LazyVim instalar os plugins automaticamente.
  3. No tmux, pressione 'prefix + I' para instalar os plugins do TPM.
  4. Finalize as runtimes:  asdf install node latest  &&  asdf install php latest
  5. Coloque seu wallpaper em ~/Imagens/wallpaper.jpg (usado pelo feh e pelo lock).

EOF

warn "SEGURANÇA: existe uma DEEPSEEK_API_KEY em texto puro dentro do arquivo 'zshrc'"
warn "rastreado pelo git. Rotacione a chave e mova-a para um arquivo não versionado"
warn "(ex.: ~/.secrets carregado via 'source'), fora do repositório."
