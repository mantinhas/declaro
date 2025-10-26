load ../test_helper/testing_base.bash

@test "declaro import works with tarball" {
  # Create a temporary directory with the correct file names
  mkdir -p temp_import
  cp "$DIR/data/packages.list.2" temp_import/packages.list
  cp "$DIR/data/config-dirty-state.sh" temp_import/config.sh
  tar -czf test.tar.gz -C temp_import packages.list config.sh
  rm -rf temp_import
  
  # Remove any existing checksum file to avoid verification issues
  rm -f test.tar.gz.sha256
  
  run $DECLARO_CMD import test.tar.gz <<< 'y'
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

  run $DECLARO_CMD import "$MOCK_REMOTE_REPO" <<< 'y'
  assert_success

  teardown_git_repo
}

@test "declaro export and import" {
  # Create a tarball from the current ETC_DECLARO_DIR
  run $DECLARO_CMD export test.tar.gz
  assert_success

  # Delete the current ETC_DECLARO_DIR
  teardown_etc_declaro
  mkdir "$ETC_DECLARO_DIR"
  
  # ETC_DECLARO_DIR is empty now
  assert_equal "$(ls -A "$ETC_DECLARO_DIR" | wc -l | tr -d ' ')" 0

  # Import the tarball back into ETC_DECLARO_DIR
  run $DECLARO_CMD import test.tar.gz <<< 'y'
  assert_success

  # The packages.list file should now match the original
  run diff $KEEPLISTFILE "$DIR/data/packages.list"
  assert_success

  rm test.tar.gz
}
