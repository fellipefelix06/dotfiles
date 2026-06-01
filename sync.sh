#!/usr/bin/env bash
# Captura o estado ATUAL do sistema (live → dotfiles). É o inverso do restore.sh.
# Copia os configs rastreados, o .bash_profile, os wallpapers e regenera as
# listas de pacotes. Não commita — só sincroniza e mostra o git status.
#
# Uso:  ./sync.sh   (depois revise e:  git add -A && git commit && git push)
set -euo pipefail
cd "$(dirname "$0")"

# Configs rastreados (adicione aqui se passar a versionar um novo dir de ~/.config)
CONFIG_DIRS=(hypr rofi kitty waybar swaync gtk-3.0 gtk-4.0 matugen)

echo ">> Sincronizando .config (live → dotfiles)..."
for d in "${CONFIG_DIRS[@]}"; do
  if [ -d "$HOME/.config/$d" ]; then
    rm -rf ".config/$d"
    cp -a "$HOME/.config/$d" ".config/$d"   # cp -a preserva symlinks (waybar)
    echo "   ✓ $d"
  else
    echo "   - $d (não existe em ~/.config, pulando)"
  fi
done

echo ">> Copiando .bash_profile..."
cp -a "$HOME/.bash_profile" ".bash_profile"

echo ">> Atualizando wallpapers (adiciona novos)..."
mkdir -p wallpapers
[ -d "$HOME/Pictures/wallpapers" ] && cp -a "$HOME/Pictures/wallpapers/." "wallpapers/"

echo ">> Regenerando listas de pacotes (estado real)..."
# explícitos em repos sync (core/extra/multilib/chaotic-aur)
pacman -Qqen | sort > pkglist-explicit.txt
# foreign/AUR de verdade, sem os pacotes -debug (lixo de build).
# { grep || true; } evita que grep sem match (código 1) derrube o set -e.
pacman -Qqem | { grep -vE -- '-debug$' || true; } | sort > pkglist-aur.txt
echo "   explicit: $(wc -l < pkglist-explicit.txt) | aur: $(wc -l < pkglist-aur.txt)"

echo
echo ">> Mudanças (git):"
git status --short || true
echo
echo "Revise acima. Para salvar:"
echo "   git add -A && git commit -m 'sync' && git push"
