load ../test_helper/testing_base.bash

@test "declaro diff works" {
  run declaro diff
  assert_output "\
+pkg5
-pkg3
-pkg4"
}

