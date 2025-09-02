KEEPLISTFILE="/etc/declaro/packages.list"

# Command to uninstall a package and its dependencies (no confirm/user prompts)
UNINSTALL_COMMAND () {
        sudo dnf remove --assumeyes $@
}
# Command to install a package and its dependencies (no confirm/user prompts)
INSTALL_COMMAND () {
        sudo dnf install --assumeyes $@
}
# Command to list all manually/explicitely installed packages
LIST_COMMAND () {
        dnf repoquery --userinstalled --qf '%{name}\n'
}
