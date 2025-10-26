load ../test_helper/testing_base.bash

@test "declaro diff works" {
  run $DECLARO_CMD diff
  assert_output "\
+pkg5
-pkg3
-pkg4"
}

