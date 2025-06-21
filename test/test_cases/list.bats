load ../test_helper/testing_base.bash

@test "declaro list shows the declared packages" {
  run declaro list
  assert_output "\
pkg1
pkg2
pkg3
pkg4"
}

