KEEPLISTFILE="/etc/declaro/packages.list"

# Command to uninstall a package and its dependencies (no confirm/user prompts)
UNINSTALL_COMMAND () {
  brew remove $@
}
# Command to install a package and its dependencies (no confirm/user prompts)
INSTALL_COMMAND () {
  brew install $@
}
# Command to list all manually/explicitely installed packages
LIST_COMMAND () {
  brew list
}
