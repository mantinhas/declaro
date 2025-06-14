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

  mkdir "$DIR/mock_etc_declaro"
  export ETC_DECLARO_DIR="$DIR/mock_etc_declaro"
  export SUDO=" "
  cp "$DIR/data/config-dirty-state.sh" "$ETC_DECLARO_DIR/config.sh"
  cp "$DIR/data/packages.list" "$ETC_DECLARO_DIR/packages.list"
  load "$DIR/../share/declaro/bin/utils.sh"
  LOAD_DECLAROCONFFILE
}


teardown() {
  teardown_etc_declaro
}

teardown_etc_declaro() {
  rm -rf "$ETC_DECLARO_DIR"
}

setup_git_repo(){
  # Create a mock git repository for testing
  MOCK_GIT_REPO="$DIR/mock_git_repo"
  MOCK_REMOTE_REPO="$DIR/mock_remote_repo"

  mkdir -p "$MOCK_REMOTE_REPO"
  cd "$MOCK_REMOTE_REPO"
  git init --bare

  mkdir -p "$MOCK_GIT_REPO"
  cd "$MOCK_GIT_REPO"
  git init
  git config commit.gpgsign false
  git config init.defaultBranch main
  cp "$DIR/data/packages.list" packages.list
  cp "$DIR/data/config-dirty-state.sh" config.sh
  git add packages.list config.sh
  git commit -m "Initial commit with packages list"
  git remote add origin "$MOCK_REMOTE_REPO"
  git push -u origin main
}

teardown_git_repo() {
  rm -rf $MOCK_GIT_REPO
  rm -rf $MOCK_REMOTE_REPO
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

@test "declaro export works" {
  run declaro export test.tar.gz
  assert_success
  run tar -tzf test.tar.gz
  for file in $(find "${ETC_DECLARO_DIR}" -type f); do
    assert_output --partial "$(basename $file)"
  done
  rm test.tar.gz
}

@test "declaro export fails without file argument" {
  run declaro export
  assert_failure
}

@test "declaro import works with tarball" {
  tar --transform='s|packages.list.2|packages.list|;s|config-dirty-state.sh|config.sh|' -czf test.tar.gz --directory="$DIR/data" packages.list.2 config-dirty-state.sh
  run declaro import test.tar.gz <<< 'y'
  assert_success
  run diff $KEEPLISTFILE "$DIR/data/packages.list.2"
  # they are the same
  assert_success
  run diff $DECLAROCONFFILE "$DIR/data/config-dirty-state.sh"
  # they are the same
  assert_success

  rm test.tar.gz
}

@test "declaro import works with git repository" {
  setup_git_repo

  run declaro import "$MOCK_REMOTE_REPO" <<< 'y'
  assert_success

  teardown_git_repo
}

@test "declaro export and import" {
  # Create a tarball from the current ETC_DECLARO_DIR
  run declaro export test.tar.gz
  assert_success

  # Delete the current ETC_DECLARO_DIR
  teardown_etc_declaro
  mkdir "$ETC_DECLARO_DIR"
  
  # ETC_DECLARO_DIR is empty now
  assert_equal "$(ls -A "$ETC_DECLARO_DIR" | wc -l)" 0

  # Import the tarball back into ETC_DECLARO_DIR
  run declaro import test.tar.gz <<< 'y'
  assert_success

  # The packages.list file should now match the original
  run diff $KEEPLISTFILE "$DIR/data/packages.list"
  assert_success

  rm test.tar.gz
}
