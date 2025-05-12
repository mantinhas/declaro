# Mock package manager interactions 
LIST_COMMAND () {
  echo -e "pkg1\npkg2\npkg5"
}
INSTALL_COMMAND () {
  true
}
UNINSTALL_COMMAND () {
  true
}
sudo () {
  $@
}
