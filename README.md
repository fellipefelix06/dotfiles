# dotfiles — Hyprland (Arch Linux)

Backup completo da configuração do meu desktop Hyprland: configs, scripts, wallpapers e lista de programas.

## Conteúdo

| Caminho | Descrição |
|---|---|
| `.config/hypr/` | Hyprland, hyprlock, hypridle, colors, scripts |
| `.config/waybar/` | Barra (com symlinks `config` e `style.css`) |
| `.config/rofi/` | Launcher |
| `.config/kitty/` | Terminal |
| `.config/swaync/` | Centro de notificações |
| `.config/gtk-3.0/`, `.config/gtk-4.0/` | Tema escuro GTK |
| `.bash_profile` | Inicia o Hyprland no TTY1 via uwsm |
| `system/getty-tty1-autologin.conf` | Autologin do TTY1 (vai em `/etc/...`) |
| `wallpapers/` | Papéis de parede |
| `pkglist-explicit.txt` | Pacotes do repositório oficial (pacman) |
| `pkglist-aur.txt` | Pacotes AUR/foreign |

## Setup do sistema (não são arquivos)

- **Fuso horário:** `America/Sao_Paulo`
- **Teclado:** US-International (`us` + variante `intl`)
- **Tema:** escuro (GTK `prefer-dark` / `Adwaita-dark`)
- **Login:** SDDM desativado → autologin no TTY1 → Hyprland via uwsm
- **Lock screen:** hyprlock (disparado pelo hypridle)

## Restaurar numa máquina nova

```bash
# 1. Instalar os programas
sudo pacman -S --needed - < pkglist-explicit.txt
# AUR (use yay/paru):
yay -S --needed - < pkglist-aur.txt

# 2. Restaurar configs e wallpapers
./restore.sh

# 3. Aplicar ajustes de sistema
sudo timedatectl set-timezone America/Sao_Paulo
sudo localectl set-x11-keymap us pc105 intl
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'

# 4. Autologin + desativar SDDM
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
sudo cp system/getty-tty1-autologin.conf /etc/systemd/system/getty@tty1.service.d/autologin.conf
sudo systemctl disable sddm.service   # se existir

# 5. Reiniciar
```

> Os symlinks do waybar (`config`, `style.css`) e `~/.config/hypr/current_wallpaper`
> usam caminhos absolutos sob `/home/fsfx`. Em outro usuário, recrie-os apontando
> para o local correto.
