KEEPLISTFILE="/etc/declaro/packages.list"

# Command to install a package and its dependencies (no confirm/user prompts)
UNINSTALL_COMMAND () {
  sudo pacman -Rns --noconfirm $@
}
# Command to install a package and its dependencies (no confirm/user prompts)
INSTALL_COMMAND () {
  yay -S --noconfirm $@
  # yay does not return error codes on some errors (package not found for example)
  # This is a workaround return error code if the package was not installed
  pacman -Qq $@ > /dev/null 2>&1 || return 1
}
# Command to list all manually/explicitely installed packages
LIST_COMMAND () {
  pacman -Qqe
}
