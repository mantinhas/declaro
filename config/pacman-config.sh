KEEPLISTFILE=${XDG_CONFIG_HOME:-$HOME/.config}/declaro/packages.list

UNINSTALL_COMMAND="sudo pacman -Rns --noconfirm"
INSTALL_COMMAND="sudo pacman -S --noconfirm"
LIST_COMMAND="pacman -Qqe"
