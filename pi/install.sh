#!/usr/bin/env bash
# ============================================================
# install.sh — Instala/configura as dotfiles do pi coding agent
# ============================================================
# Uso:
#   ./install.sh                  # Cria symlinks (modo seguro)
#   ./install.sh --copy           # Copia arquivos (sem symlinks)
#   ./install.sh --dry-run        # Mostra o que seria feito
#   ./install.sh --restore        # Restaura do backup (se existir)
# ============================================================

set -euo pipefail

DOTDIR="$(cd "$(dirname "$0")" && pwd)"
PI_DIR="$HOME/.pi/agent"
MODE="symlink"
DRY_RUN=false

for arg in "$@"; do
  case "$arg" in
    --copy)     MODE="copy"    ;;
    --dry-run)  DRY_RUN=true   ;;
    --restore)  MODE="restore" ;;
  esac
done

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}  🎯 Pi — Instalação de configurações${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Cria diretórios necessários
mkdir -p "$PI_DIR/themes" "$PI_DIR/extensions"

link_file() {
  local src="$1"
  local dst="$2"
  local label="$3"

  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo -e "  ✅ ${GREEN}OK${NC} $label (já linkado)"
    return
  fi

  if [ -f "$dst" ] || [ -L "$dst" ]; then
    local bak="${dst}.bak.$(date +%s)"
    echo -e "  ⚡  ${YELLOW}Backup${NC} $label → $(basename "$bak")"
    $DRY_RUN || mv "$dst" "$bak"
  fi

  echo -e "  🔗  ${GREEN}Linkando${NC} $label"
  $DRY_RUN || ln -s "$src" "$dst"
}

copy_file() {
  local src="$1"
  local dst="$2"
  local label="$3"

  if [ -f "$dst" ]; then
    local bak="${dst}.bak.$(date +%s)"
    echo -e "  ⚡  ${YELLOW}Backup${NC} $label → $(basename "$bak")"
    $DRY_RUN || mv "$dst" "$bak"
  fi

  echo -e "  📄 ${GREEN}Copiando${NC} $label"
  $DRY_RUN || cp "$src" "$dst"
}

# ---- Restore mode ----
if [ "$MODE" = "restore" ]; then
  echo -e "\n${YELLOW}📦 Restaurando backups...${NC}"
  for bak in "$PI_DIR"/*.bak.*; do
    [ -f "$bak" ] || continue
    original="${bak%.bak.*}"
    echo -e "  ↻  Restaurando $(basename "$original")"
    $DRY_RUN || mv "$bak" "$original"
  done
  echo -e "\n${GREEN}✅ Backups restaurados! Remova os symlinks manualmente se necessário.${NC}"
  exit 0
fi

# ---- Instalação ----
echo -e "\n${CYAN}📋 Configurações:${NC}"
if [ "$MODE" = "copy" ]; then
  copy_file "$DOTDIR/settings.json" "$PI_DIR/settings.json" "settings.json"
else
  link_file "$DOTDIR/settings.json" "$PI_DIR/settings.json" "settings.json"
fi

echo -e "\n${CYAN}🎨 Temas:${NC}"
for theme in "$DOTDIR"/themes/*.json; do
  [ -f "$theme" ] || continue
  name=$(basename "$theme")
  if [ "$MODE" = "copy" ]; then
    copy_file "$theme" "$PI_DIR/themes/$name" "themes/$name"
  else
    link_file "$theme" "$PI_DIR/themes/$name" "themes/$name"
  fi
done

echo -e "\n${CYAN}🧩 Extensões:${NC}"
for ext in "$DOTDIR"/extensions/*.ts; do
  [ -f "$ext" ] || continue
  name=$(basename "$ext")
  if [ "$MODE" = "copy" ]; then
    copy_file "$ext" "$PI_DIR/extensions/$name" "extensions/$name"
  else
    link_file "$ext" "$PI_DIR/extensions/$name" "extensions/$name"
  fi
done

echo ""
if [ "$DRY_RUN" = true ]; then
  echo -e "${YELLOW}📌 Dry-run — nada foi alterado.${NC}"
else
  echo -e "${GREEN}✅ Instalação concluída!${NC}"
  echo -e "   Inicie o pi ou use ${CYAN}/reload${NC} para carregar as novas configs."
fi
