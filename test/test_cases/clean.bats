load ../test_helper/testing_base.bash

@test "declaro clean removes and installs packages" {
  run declaro clean
  assert_line -n 1 "The following 1 package(s) are strayed (installed but not declared in packages.list):"
  assert_line -n 2 -e "\spkg5"
  assert_line -n 6 "The following 2 package(s) are missing (declared in packages.list but not installed):"
  assert_line -n 7 -e "\spkg3 pkg4"
}

@test "declaro clean deals with errors in installing and uninstalling" {
  export DECLAROCONFFILE="$DIR/data/config-errors.sh"
  run declaro clean
  assert_output --partial "test case error message uninstall"
  assert_output --partial "test case error message install"
  
}

@test "declaro clean does nothing if no packages are strayed or missing" {
  export DECLAROCONFFILE="$DIR/data/config-clean-state.sh"

  run declaro clean
  assert_line -n 1 "There are no stray packages. Nothing to remove."
  assert_line -n 3 "There are no missing packages. Nothing to install."
}

