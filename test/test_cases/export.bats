load ../test_helper/testing_base.bash

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

