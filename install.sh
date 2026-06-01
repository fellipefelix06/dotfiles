#!/usr/bin/env bash
# Instalação completa do ambiente Hyprland a partir deste repo.
# Uso: ./install.sh   (vai pedir senha do sudo quando necessário)
set -euo pipefail
cd "$(dirname "$0")"
USER_NAME="$(whoami)"

echo "=============================================="
echo " Instalação do ambiente Hyprland — usuário: $USER_NAME"
echo "=============================================="

# ---------------------------------------------------------------------------
# 1. Programas
# ---------------------------------------------------------------------------
echo
echo ">> [1/4] Instalando pacotes do repositório oficial (pacman)..."
sudo pacman -S --needed --noconfirm - < pkglist-explicit.txt

if [ -s pkglist-aur.txt ]; then
  AUR=""
  for h in yay paru; do command -v "$h" >/dev/null 2>&1 && AUR="$h" && break; done
  if [ -n "$AUR" ]; then
    echo ">> Instalando pacotes AUR com $AUR..."
    "$AUR" -S --needed --noconfirm - < pkglist-aur.txt
  else
    echo "!! Nenhum helper AUR (yay/paru) encontrado. Instale manualmente:"
    cat pkglist-aur.txt | sed 's/^/   - /'
  fi
fi

# ---------------------------------------------------------------------------
# 2. Configs e wallpapers
# ---------------------------------------------------------------------------
echo
echo ">> [2/4] Restaurando configs e wallpapers..."
cp -a .config/. "$HOME/.config/"
cp -a .bash_profile "$HOME/.bash_profile"
mkdir -p "$HOME/Pictures"
cp -a wallpapers "$HOME/Pictures/wallpapers"

# ---------------------------------------------------------------------------
# 3. Fuso, teclado e tema
# ---------------------------------------------------------------------------
echo
echo ">> [3/4] Ajustando fuso, teclado e tema escuro..."
sudo timedatectl set-timezone America/Sao_Paulo
sudo localectl set-x11-keymap us pc105 intl
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'

# ---------------------------------------------------------------------------
# 4. Autologin no TTY1 + desativar SDDM
# ---------------------------------------------------------------------------
echo
echo ">> [4/4] Configurando autologin no TTY1 e desativando SDDM..."
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
# substitui 'fsfx' pelo usuário atual, caso seja diferente
sed "s/--autologin fsfx/--autologin $USER_NAME/" system/getty-tty1-autologin.conf \
  | sudo tee /etc/systemd/system/getty@tty1.service.d/autologin.conf >/dev/null
sudo systemctl disable sddm.service 2>/dev/null || echo "   (sddm não estava ativo, ok)"

echo
echo "=============================================="
echo " Concluído! Reinicie a máquina:  reboot"
echo "=============================================="
