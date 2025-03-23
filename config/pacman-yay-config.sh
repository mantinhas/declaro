KEEPLISTFILE=${XDG_CONFIG_HOME:-$HOME/.config}/declaro/packages.list

UNINSTALL_COMMAND="sudo pacman -Rns --noconfirm"
INSTALL_COMMAND="yay -S --noconfirm"
LIST_COMMAND="pacman -Qqe"
