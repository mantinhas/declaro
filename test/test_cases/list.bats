load ../test_helper/testing_base.bash

@test "declaro list shows the declared packages" {
  run $DECLARO_CMD list
  assert_output "\
pkg1
pkg2
pkg3
pkg4"
}

