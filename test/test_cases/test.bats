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
  load "$DIR/../share/pacmark/utils.sh"
  export PATH=$DIR/../bin/:$PATH
  cp $DIR/data/packages.list $DIR/data/packages.list.1
  export KEEPLISTFILE=$DIR/data/packages.list.1

  # Mock package manager interactions 
  export LIST_COMMAND="echo -e pkg1\npkg2\npkg5"
  export INSTALL_COMMAND="true"
  export UNINSTALL_COMMAND="true"
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

@test "utils: filter_unmarked works" {
  run filter_unmarkedpkgs "pkg1 pkg2 pkg4 pkg5 pkg6"
  assert_output "\
pkg5
pkg6"
}

@test "utils: filter_marked works" {
  run filter_markedpkgs "pkg1 pkg2 pkg4 pkg5 pkg6"
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

@test "pacmark clean removes and installs packages" {
  run pacmark clean
  assert_line -n 0 "The following 1 package(s) are strayed (installed but not declared in packages.list):"
  assert_line -n 1 -e "\spkg5"
  assert_line -n 4 "The following 2 package(s) are missing (declared in packages.list but not installed):"
  assert_line -n 5 -e "\spkg3 pkg4"
}

@test "pacmark clean does nothing if no packages are strayed or missing" {
  export LIST_COMMAND="echo -e pkg1\npkg2\npkg3\npkg4"
  run pacmark clean
  assert_line -n 0 "There are no stray packages. Nothing to remove."
  assert_line -n 1 "There are no missing packages. Nothing to install."
}

@test "pacmark diff works" {
  run pacmark diff
  assert_output "\
+pkg5
-pkg3
-pkg4"
}

@test "pacmark generate creates a keepfile correctly" {
  rm $KEEPLISTFILE
  run pacmark generate
  assert_output -e "Generating new packages.list file containing 3 packages:
\spkg1 pkg2 pkg5"
}

@test "pacmark list shows the marked packages" {
  run pacmark list
  assert_output "\
pkg1
pkg2
pkg3
pkg4"
}

@test "pacmark mark marks packages and detects already marked" {
  run pacmark mark pkg5 pkg6 pkg3
  assert_output -e "\
Packages already marked:
\spkg3
Marking packages:
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

@test "pacmark status works" {
  run pacmark status pkg1 pkg2 pkg3 pkg4 pkg5 pkg6
  assert_output "\
pkg1
installed: yes
marked: yes
pkg2
installed: yes
marked: yes
pkg3
installed: no
marked: yes
pkg4
installed: no
marked: yes
pkg5
installed: yes
marked: no
pkg6
installed: no
marked: no"
}

