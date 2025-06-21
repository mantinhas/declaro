load ../test_helper/testing_base.bash

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

