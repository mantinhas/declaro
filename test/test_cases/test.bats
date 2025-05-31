setup_file() {
  echo -e "\n" | make SUDO= PREFIX=test install > /dev/null
}

teardown_file() {
  make SUDO= PREFIX=test uninstall > /dev/null
  rmdir test/bin test/share
}

setup() {
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"

  load "$DIR/../test_helper/bats-support/load"
  load "$DIR/../test_helper/bats-assert/load"
  export PATH=$DIR/../bin/:$PATH
  cp "$DIR/data/packages.list" "$DIR/data/packages.list.1"

  export DECLAROCONFFILE="$DIR/data/config-dirty-state.sh"
  export KEEPLISTFILE="$DIR/data/packages.list.1"
  load "$DIR/../share/declaro/bin/utils.sh"
}


teardown() {
  rm $KEEPLISTFILE
}

@test "utils: parsing keepfile works" {
  run parse_keepfile $KEEPLISTFILE
  assert_output "\
pkg1
pkg2
pkg3
pkg4"
}

@test "utils: get_missing_pkgs works" {
  run get_missing_pkgs
  assert_output "\
pkg3
pkg4"
}

@test "utils: get_stray_pkgs works" {
  run get_stray_pkgs
  assert_output "\
pkg5"
}

@test "utils: filter_undeclared works" {
  run filter_undeclaredpkgs "pkg1 pkg2 pkg4 pkg5 pkg6"
  assert_output "\
pkg5
pkg6"
}

@test "utils: filter_declared works" {
  run filter_declaredpkgs "pkg1 pkg2 pkg4 pkg5 pkg6"
  assert_output "\
pkg1
pkg2
pkg4"
}

@test "utils: diff_keepfile_installed works" {
  run diff_keepfile_installed
  assert_output "\
+pkg5
-pkg3
-pkg4"
}

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

@test "declaro diff works" {
  run declaro diff
  assert_output "\
+pkg5
-pkg3
-pkg4"
}

@test "declaro generate creates a keepfile correctly" {
  rm $KEEPLISTFILE
  run declaro generate
  source $DECLAROCONFFILE
  LIST_COMMAND
  assert_output -e "Generating new packages.list file containing 3 packages:
\spkg1 pkg2 pkg5"
}

@test "declaro list shows the declared packages" {
  run declaro list
  assert_output "\
pkg1
pkg2
pkg3
pkg4"
}

@test "declaro declare works and detects already declared" {
  run declaro declare pkg5 pkg6 pkg3
  assert_output -e "\
Packages already declared:
\spkg3
Declaring packages:
\spkg5 pkg6"
  run parse_keepfile $KEEPLISTFILE
  assert_output "\
pkg1
pkg2
pkg3
pkg4
pkg5
pkg6"
}

@test "declaro status works" {
  run declaro status pkg1 pkg2 pkg3 pkg4 pkg5 pkg6
  assert_output "\
pkg1
installed: yes
declared: yes
pkg2
installed: yes
declared: yes
pkg3
installed: no
declared: yes
pkg4
installed: no
declared: yes
pkg5
installed: yes
declared: no
pkg6
installed: no
declared: no"
}

