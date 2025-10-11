load ../test_helper/testing_base.bash

@test "declaro declare works and detects already declared" {
  run $DECLARO_CMD declare pkg5 pkg6 pkg3
  assert_output -e "\
Packages already declared:
	pkg3
Declaring packages:
	pkg5 pkg6"
  run parse_keepfile $KEEPLISTFILE
  assert_output "\
pkg1
pkg2
pkg3
pkg4
pkg5
pkg6"
}

