load ../test_helper/testing_base.bash

@test "parsing keepfile works" {
  run parse_keepfile $KEEPLISTFILE
  assert_output "\
pkg1
pkg2
pkg3
pkg4"
}

@test "get_missing_pkgs works" {
  run get_missing_pkgs
  assert_output "\
pkg3
pkg4"
}

@test "get_stray_pkgs works" {
  run get_stray_pkgs
  assert_output "\
pkg5"
}

@test "filter_undeclared works" {
  run filter_undeclaredpkgs "pkg1 pkg2 pkg4 pkg5 pkg6"
  assert_output "\
pkg5
pkg6"
}

@test "filter_declared works" {
  run filter_declaredpkgs "pkg1 pkg2 pkg4 pkg5 pkg6"
  assert_output "\
pkg1
pkg2
pkg4"
}

@test "diff_keepfile_installed works" {
  run diff_keepfile_installed
  assert_output "\
+pkg5
-pkg3
-pkg4"
}

