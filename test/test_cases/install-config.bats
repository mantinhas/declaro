load ../test_helper/testing_base.bash

@test "declaro install-config prompts for confirmation" {
    export TEST_PACKAGE_MANAGER="none"
    run bash -c "echo n | bash $DIR/data/test-install-config.sh"
    assert_output "Operation canceled - no changes were made."
}

@test "declaro install-config installs config file for pacman without AUR" {
    export TEST_PACKAGE_MANAGER="pacman"
    run bash -c "echo y | bash $DIR/data/test-install-config.sh"
    assert_success
    run diff $DECLAROCONFFILE "$TEST_PREFIX/share/declaro/config/pacman-config.sh"
    #they are the same
    assert_success
}

@test "declaro install-config installs config file for pacman with paru" {
    export TEST_PACKAGE_MANAGER="pacman-paru"
    run bash -c "echo y | bash $DIR/data/test-install-config.sh"
    assert_success
    run diff $DECLAROCONFFILE "$TEST_PREFIX/share/declaro/config/pacman-paru-config.sh"
    #they are the same
    assert_success
}

@test "declaro install-config installs config file for dnf" {
    export TEST_PACKAGE_MANAGER="dnf"
    run bash -c "echo y | bash $DIR/data/test-install-config.sh"
    assert_success
    run diff $DECLAROCONFFILE "$TEST_PREFIX/share/declaro/config/dnf-config.sh"
    #they are the same
    assert_success
}

@test "declaro install-config installs config file for apt" {
    export TEST_PACKAGE_MANAGER="apt"
    run bash -c "echo y | bash $DIR/data/test-install-config.sh"
    assert_success
    run diff $DECLAROCONFFILE "$TEST_PREFIX/share/declaro/config/apt-config.sh"
    #they are the same
    assert_success
}

@test "declaro install-config errors if no supported package manager is found" {
    export TEST_PACKAGE_MANAGER="none"
    run bash -c "echo y | bash $DIR/data/test-install-config.sh"
    assert_failure
}
