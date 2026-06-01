#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Inicia o Hyprland automaticamente ao logar no TTY1 (via uwsm).
# uwsm check may-start só retorna sucesso no VT de login sem sessão gráfica ativa.
if uwsm check may-start; then
    exec uwsm start -e -D Hyprland hyprland.desktop
fi
