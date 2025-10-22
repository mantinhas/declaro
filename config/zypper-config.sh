KEEPLISTFILE="/etc/declaro/packages.list"

# Command to uninstall a package and its dependencies (no confirm/user prompts)
UNINSTALL_COMMAND () {
  sudo zypper remove --no-confirm $@
}
# Command to install a package and its dependencies (no confirm/user prompts)
INSTALL_COMMAND () {
  sudo zypper install --no-confirm $@
}
# Command to list all manually/explicitly installed packages
LIST_COMMAND () {
  zypper search --installed-only | awk '/^i\+/ {print $3}'
}
