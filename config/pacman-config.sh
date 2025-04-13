KEEPLISTFILE="/etc/declaro/packages.list"

# Command to install a package and its dependencies (no confirm/user prompts)
UNINSTALL_COMMAND="sudo pacman -Rns --noconfirm"
# Command to install a package and its dependencies (no confirm/user prompts)
INSTALL_COMMAND="sudo pacman -S --noconfirm"
# Command to list all manually/explicitely installed packages
LIST_COMMAND="pacman -Qqe"
