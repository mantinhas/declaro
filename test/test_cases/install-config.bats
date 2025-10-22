load ../test_helper/testing_base.bash

@test "declaro install-config prompts for confirmation" {
    function apt {
      return 1
    }
    function dnf {
      return 1
    }
    function pacman {
      return 1
    }
    function zypper {
      return 1
    }
    export -f apt dnf pacman
    run bash -c "echo n | declaro install-config"
    assert_output "Operation canceled - no changes were made."
}

@test "declaro install-config installs config file for pacman without AUR" {
    function apt {
      return 1
    }
    function dnf {
      return 1
    }
    function pacman {
      if [[ "$1" == "--version" ]]; then
        return 0
      elif [[ "$1" == "-Qq" && "$2" == "paru" ]]; then
        return 1 # paru not installed
      elif [[ "$1" == "-Qq" && "$2" == "yay" ]]; then
        return 1 # yay not installed
      else 
        return 0 # pacman command exists
      fi
    }
    function zypper {
      return 1
    }
    export -f apt dnf pacman
    run bash -c "echo y | declaro install-config"
    assert_success
    run diff $DECLAROCONFFILE "test/share/declaro/config/pacman-config.sh"
    #they are the same
    assert_success
}

@test "declaro install-config installs config file for pacman with paru" {
    function apt {
      return 1
    }
    function dnf {
      return 1
    }
    function pacman {
      if [[ "$1" == "--version" ]]; then
        return 0
      elif [[ "$1" == "-Qq" && "$2" == "paru" ]]; then
        return 0 # paru not installed
      elif [[ "$1" == "-Qq" && "$2" == "yay" ]]; then
        return 1 # yay not installed
      else 
        return 0 # pacman command exists
      fi
    }
    function zypper {
      return 1
    }
    export -f apt dnf pacman
    run bash -c "echo y | declaro install-config"
    assert_success
    run diff $DECLAROCONFFILE "test/share/declaro/config/pacman-paru-config.sh"
    #they are the same
    assert_success
}

@test "declaro install-config installs config file for dnf" {
    function apt {
      return 1
    }
    function dnf {
      return 0
    }
    function pacman {
      return 1
    }
    function zypper {
      return 1
    }
    export -f apt dnf pacman
    run bash -c "echo y | declaro install-config"
    assert_success
    run diff $DECLAROCONFFILE "test/share/declaro/config/dnf-config.sh"
    #they are the same
    assert_success
}

@test "declaro install-config installs config file for apt" {
    function apt {
      return 0
    }
    function dnf {
      return 1
    }
    function pacman {
      return 1
    }
    function zypper {
      return 1
    }
    export -f apt dnf pacman
    run bash -c "echo y | declaro install-config"
    assert_success
    run diff $DECLAROCONFFILE "test/share/declaro/config/apt-config.sh"
    #they are the same
    assert_success
}

@test "declaro install-config installs config file for zypper" {
    function apt {
      return 1
    }
    function dnf {
      return 1
    }
    function pacman {
      return 1
    }
    function zypper {
      return 0
    }
    export -f apt dnf pacman zypper
    run bash -c "echo y | declaro install-config"
    assert_success
    run diff $DECLAROCONFFILE "test/share/declaro/config/zypper-config.sh"
    assert_success
}

@test "declaro install-config errors if no supported package manager is found" {
    function apt {
      return 1
    }
    function dnf {
      return 1
    }
    function pacman {
      return 1
    }
    function zypper {
      return 1
    }
    export -f apt dnf pacman
    run bash -c "echo y | declaro install-config"
    assert_failure
}
