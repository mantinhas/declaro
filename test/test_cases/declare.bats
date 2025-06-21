load ../test_helper/testing_base.bash

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

