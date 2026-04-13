KEEPLISTFILE="/etc/declaro/packages.list"

# Command to uninstall a package and its dependencies (no confirm/user prompts)
UNINSTALL_COMMAND () {
  sudo pacman -D --asdeps $@
  sudo pacman -Qdtq | sudo pacman -Rns --noconfirm -
}
# Command to install a package and its dependencies (no confirm/user prompts)
INSTALL_COMMAND () {
  sudo pacman -S --noconfirm --needed $@
  sudo pacman -D --asexplicit $@
}
# Command to list all manually/explicitely installed packages
LIST_COMMAND () {
  pacman -Qqen
}
