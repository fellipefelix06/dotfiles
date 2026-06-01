#!/usr/bin/env bash
# Restaura configs e wallpapers deste repo para a home do usuário.
set -euo pipefail
cd "$(dirname "$0")"

echo ">> Copiando .config ..."
cp -a .config/. "$HOME/.config/"

echo ">> Copiando .bash_profile ..."
cp -a .bash_profile "$HOME/.bash_profile"

echo ">> Copiando wallpapers ..."
mkdir -p "$HOME/Pictures"
cp -a wallpapers "$HOME/Pictures/wallpapers"

echo ">> Pronto. Veja o README para os ajustes de sistema (fuso, teclado, autologin, tema)."
