load ../test_helper/testing_base.bash

@test "declaro clean removes and installs packages" {
  # Ensure test installation exists
  if [ ! -f "$TEST_PREFIX/bin/declaro" ]; then
    echo -e "\n" | make SUDO= PREFIX="$TEST_PREFIX" install > /dev/null
  fi
  
  run $DECLARO_CMD clean
  assert_output --partial "The following 1 package(s) are strayed (installed but not declared in packages.list):"
  assert_output --partial "pkg5"
  assert_output --partial "The following 2 package(s) are missing (declared in packages.list but not installed):"
  assert_output --partial "pkg3 pkg4"
}

@test "declaro clean deals with errors in installing and uninstalling" {
  export DECLAROCONFFILE="$DIR/data/config-errors.sh"
  run $DECLARO_CMD clean
  assert_output --partial "test case error message uninstall"
  assert_output --partial "test case error message install"
  
}

@test "declaro clean does nothing if no packages are strayed or missing" {
  export DECLAROCONFFILE="$DIR/data/config-clean-state.sh"

  run $DECLARO_CMD clean
  assert_line -n 1 "There are no stray packages. Nothing to remove."
  assert_line -n 3 "There are no missing packages. Nothing to install."
}

