KEEPLISTFILE="/etc/declaro/packages.list"

# Command to uninstall a package and its dependencies (no confirm/user prompts)
UNINSTALL_COMMAND () {
  sudo apt-get remove $@ -y
}
# Command to install a package and its dependencies (no confirm/user prompts)
INSTALL_COMMAND () {
  sudo apt-get install $@ -y
}
# Command to list all manually/explicitely installed packages
LIST_COMMAND () {
  apt-mark showmanual
}
