# Mock package manager interactions 
LIST_COMMAND () {
  echo -e "pkg1\npkg2\npkg3\npkg4"
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
