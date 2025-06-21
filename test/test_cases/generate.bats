load ../test_helper/testing_base.bash

@test "declaro generate creates a keepfile correctly" {
  rm $KEEPLISTFILE
  run declaro generate
  source $DECLAROCONFFILE
  LIST_COMMAND
  assert_output -e "Generating new packages.list file containing 3 packages:
\spkg1 pkg2 pkg5"
}

