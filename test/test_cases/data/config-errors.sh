# Mock package manager interactions 
LIST_COMMAND () {
  echo -e "pkg1\npkg2\npkg5"
}
INSTALL_COMMAND () {
  echo "test case error message install"
  return 1
}
UNINSTALL_COMMAND () {
  echo "test case error message uninstall"
  return 1
}
