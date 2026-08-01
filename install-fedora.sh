#!/usr/bin/env bash
#
# install-fedora.sh — Setup completo do ambiente para Fedora Workstation
#
# Instala toda a stack: i3wm + Alacritty + Neovim (LazyVim) + tmux + zsh (pure)
# + asdf + i3lock-color (compilado) + fontes Nerd + utilitários de CLI.
#
# Baseado nos dotfiles do repositório (./install.sh usado em Pop!_OS 22.04).
# Faz links simbólicos in-place, com backup de arquivos existentes.
#
# Uso:  ./install-fedora.sh
#
# Requisitos: Fedora 38+ (testado em Fedora 40/41), conexão com internet,
#             usuário com sudo (NOPASSWD recomendado, ou pedir senha).
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

# ---------------------------------------------------------------------------
# 0. Sanidade: Fedora + sudo
# ---------------------------------------------------------------------------
if [ ! -f /etc/os-release ]; then
  err "/etc/os-release ausente. Impossível detectar a distribuição."
  exit 1
fi
. /etc/os-release
if [ "${ID:-}" != "fedora" ]; then
  err "Este script é para Fedora. Detectado: ${PRETTY_NAME:-desconhecido}"
  exit 1
fi
if ! command -v sudo >/dev/null 2>&1; then
  err "sudo não encontrado. Instale-o antes (dnf install sudo) e adicione o usuário ao grupo wheel."
  exit 1
fi
if ! sudo -n true 2>/dev/null; then
  warn "Será solicitada a senha de sudo algumas vezes durante a instalação."
fi

FEDORA_VER="${VERSION_ID:-0}"
info "Detectado: ${PRETTY_NAME} (${FEDORA_VER})"

mkdir -p "$FONT_DIR" "$LOCAL_BIN" "$HOME/.config"

echo -e "${BLUE}🚀 Setup do ambiente (Fedora) a partir de: ${DOTFILES_DIR}${NC}"

# ---------------------------------------------------------------------------
# 1. Pacotes do sistema (DNF)
#    - xorg-x11-server-utils traz xset/xrdb
#    - pipewire-pulseaudio garante pactl
#    - polkit-gnome (não policykit-1-gnome)
#    - maim, picom, i3blocks, rofi, etc. estão todos no Fedora oficial
#    - autoconf bison re2c + devels abaixo são p/ compilar PHP via asdf
# ---------------------------------------------------------------------------
log "Atualizando o sistema e instalando pacotes..."
sudo dnf upgrade -y --refresh >/dev/null
sudo dnf install -y --skip-unavailable \
  git curl wget unzip ca-certificates gnupg2 \
  gcc gcc-c++ make cmake pkgconf-pkg-config \
  autoconf automake libtool stow \
  zsh tmux ripgrep fd-find fzf \
  i3 i3status i3blocks rofi picom numlockx xss-lock brightnessctl \
  maim xclip xrandr \
  network-manager-applet polkit-gnome \
  xorg-x11-server-utils xorg-x11-xauth xorg-x11-fonts-core \
  firefox \
  python3 fontconfig \
  alacritty \
  pulseaudio-utils \
  ImageMagick \
  cairo-devel fontconfig-devel libev-devel libjpeg-turbo-devel \
  libXinerama-devel libxkbcommon-devel libxkbcommon-x11-devel \
  libXrandr-devel pam-devel \
  xcb-util-image-devel xcb-util-xrm-devel \
  libxcb-devel libxcb-composite-devel libxcb-xkb-devel \
  libxcb-randr-devel libxcb-xinerama-devel libxcb-image-devel \
  libxcb-util-devel \
  giflib-devel \
  autoconf bison re2c libxml2-devel sqlite-devel oniguruma-devel \
  libcurl-devel gd-devel libpq-devel libzip-devel openssl-devel \
  libedit-devel libicu-devel libjpeg-devel readline-devel

# ---------------------------------------------------------------------------
# 2. Neovim (binário oficial mais recente)
#    O pacote "neovim" do Fedora costuma estar 1 versão atrás; baixamos
#    o release mais novo direto do GitHub para casar com LazyVim.
# ---------------------------------------------------------------------------
if ! command -v nvim >/dev/null 2>&1 || [ "$(nvim --version 2>/dev/null | head -1 | awk '{print $2}' | tr -d 'v')" \< "0.10" ]; then
  log "Instalando Neovim (binário oficial)..."
  NVIM_TMP="$(mktemp -d)"
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
  if command -v nvim >/dev/null 2>&1; then
    info "Neovim: $(nvim --version | head -1)"
  else
    err "Falha ao instalar Neovim. Prosseguindo com a versão do sistema, se houver."
  fi
else
  info "Neovim já instalado: $(nvim --version | head -1)"
fi

# ---------------------------------------------------------------------------
# 3. Nerd Fonts (JetBrainsMono p/ Alacritty, Meslo p/ i3bar/pure)
# ---------------------------------------------------------------------------
NF_VERSION="v3.2.1"
install_nerd_font() {
  local name="$1"
  if [ -d "$FONT_DIR/$name" ] && [ -n "$(ls -A "$FONT_DIR/$name" 2>/dev/null)" ]; then
    info "Fonte $name já instalada"
    return
  fi
  log "Instalando Nerd Font: $name..."
  mkdir -p "$FONT_DIR/$name"
  local tmp; tmp="$(mktemp)"
  if curl -fL "https://github.com/ryanoasis/nerd-fonts/releases/download/${NF_VERSION}/${name}.zip" -o "$tmp"; then
    unzip -o -q "$tmp" -d "$FONT_DIR/$name"
  else
    warn "Falha ao baixar $name (verifique a versão $NF_VERSION)."
  fi
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

# fzf — instala keybindings/completion se ainda não existirem
if [ ! -f "$HOME/.fzf.zsh" ]; then
  log "Instalando keybindings do fzf..."
  if [ -d /usr/share/fzf ]; then
    # Fedora: fzf inclui os scripts; basta linkar.
    [ -f /usr/share/fzf/key-bindings.zsh ] && ln -sf /usr/share/fzf/key-bindings.zsh "$HOME/.fzf.zsh" || true
  fi
fi

# ---------------------------------------------------------------------------
# 5. lsd (não empacotado no Fedora — baixa do GitHub)
# ---------------------------------------------------------------------------
if ! command -v lsd >/dev/null 2>&1; then
  log "Instalando lsd..."
  LSD_VER="1.2.0"
  ARCH="$(uname -m)"
  case "$ARCH" in
    x86_64)  LSD_ARCH="x86_64-unknown-linux-gnu" ;;
    aarch64) LSD_ARCH="aarch64-unknown-linux-gnu" ;;
    *) err "Arquitetura não suportada para lsd: $ARCH"; LSD_ARCH="" ;;
  esac
  if [ -n "$LSD_ARCH" ]; then
    tmp="$(mktemp -d)"
    if curl -fL "https://github.com/lsd-rs/lsd/releases/download/v${LSD_VER}/lsd-v${LSD_VER}-${LSD_ARCH}.tar.gz" -o "$tmp/lsd.tar.gz"; then
      tar -C "$tmp" -xzf "$tmp/lsd.tar.gz"
      sudo install -m 0755 "$tmp/lsd-v${LSD_VER}-${LSD_ARCH}/lsd" /usr/local/bin/lsd
      info "lsd instalado em /usr/local/bin/lsd"
    else
      warn "Não foi possível baixar lsd ${LSD_VER} (arch=${LSD_ARCH})."
    fi
    rm -rf "$tmp"
  fi
else
  info "lsd já instalado"
fi

# ---------------------------------------------------------------------------
# 6. asdf + plugins
# ---------------------------------------------------------------------------
if ! command -v asdf >/dev/null 2>&1 && [ ! -x "$LOCAL_BIN/asdf" ]; then
  log "Instalando asdf (binário Go)..."
  ASDF_VER="v0.20.0"
  ARCH="$(uname -m)"
  case "$ARCH" in
    x86_64)  ASDF_ARCH="amd64" ;;
    aarch64) ASDF_ARCH="arm64" ;;
    *) err "Arquitetura não suportada para asdf: $ARCH"; ASDF_ARCH="" ;;
  esac
  if [ -n "$ASDF_ARCH" ]; then
    tmp="$(mktemp -d)"
    if curl -fL "https://github.com/asdf-vm/asdf/releases/download/${ASDF_VER}/asdf-${ASDF_VER}-linux-${ASDF_ARCH}.tar.gz" -o "$tmp/asdf.tar.gz"; then
      tar -C "$tmp" -xzf "$tmp/asdf.tar.gz"
      install -m 0755 "$tmp/asdf" "$LOCAL_BIN/asdf"
      info "asdf instalado em $LOCAL_BIN/asdf"
    else
      warn "Falha ao baixar asdf $ASDF_VER (arch=$ASDF_ARCH)."
    fi
    rm -rf "$tmp"
  fi
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
  if [ -L "$dst" ] && [ "$(readlink -f "$dst")" = "$(readlink -f "$src")" ]; then
    return
  fi
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    mv "$dst" "${dst}.bak.$(date +%s)"
    info "Backup: $dst -> ${dst}.bak"
  fi
  ln -sfn "$src" "$dst"
  info "$dst -> $src"
}

link "$DOTFILES_DIR/nvim"          "$HOME/.config/nvim"
link "$DOTFILES_DIR/alacritty"     "$HOME/.config/alacritty"
link "$DOTFILES_DIR/zshrc"         "$HOME/.zshrc"
link "$DOTFILES_DIR/.tmux.conf"    "$HOME/.tmux.conf"
link "$DOTFILES_DIR/.tmux.conf.local" "$HOME/.tmux.conf.local"
link "$DOTFILES_DIR/picom.conf"    "$HOME/.config/picom.conf"
link "$DOTFILES_DIR/config"        "$HOME/.config/i3/config"
link "$DOTFILES_DIR/i3blocks.conf" "$HOME/.config/i3/i3blocks.conf"
link "$DOTFILES_DIR/lock"          "$HOME/.config/i3/lock"
[ -f "$DOTFILES_DIR/.Xresources" ] && link "$DOTFILES_DIR/.Xresources" "$HOME/.Xresources"

chmod +x "$DOTFILES_DIR/lock" \
         "$DOTFILES_DIR/tmux-new-session.sh" 2>/dev/null || true

# ---------------------------------------------------------------------------
# 9. i3lock-color (compilado — usado pelo script ~/.config/i3/lock)
#    Dependências Fedora (do README oficial):
#      autoconf automake cairo-devel fontconfig gcc libev-devel
#      libjpeg-turbo-devel libXinerama-devel libxkbcommon-devel
#      libxkbcommon-x11-devel libXrandr-devel pam-devel pkgconf
#      xcb-util-image-devel xcb-util-xrm-devel
# ---------------------------------------------------------------------------
if ! command -v i3lock >/dev/null 2>&1 || ! i3lock --help 2>&1 | grep -q 'clock'; then
  log "Compilando i3lock-color..."
  I3LC_TMP="$(mktemp -d)"
  git clone --depth=1 https://github.com/Raymo111/i3lock-color.git "$I3LC_TMP"
  (
    cd "$I3LC_TMP"
    git tag -f "git-$(git rev-parse --short HEAD)"
    autoreconf -i
    ./configure --prefix=/usr/local
    make -j"$(nproc)"
    sudo make install
  )
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
     - Se não aparecer: instale um gerenciador de login (lightdm, gdm, sddm).
  2. Abra o Neovim (\`nvim\`) — o LazyVim baixa os plugins automaticamente.
  3. No tmux, pressione 'prefix + I' (Ctrl-a + I) para instalar os plugins do TPM.
  4. Finalize as runtimes:   asdf install node latest && asdf install php latest
EOF

info "Secrets opcionais são carregados de ~/.secrets, fora do repositório."
