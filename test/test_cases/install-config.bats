load ../test_helper/testing_base.bash

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
    export -f apt dnf pacman
    run declaro install-config
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
    export -f apt dnf pacman
    run declaro install-config
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
    export -f apt dnf pacman
    run declaro install-config
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
    export -f apt dnf pacman
    run declaro install-config
    assert_success
    run diff $DECLAROCONFFILE "test/share/declaro/config/apt-config.sh"
    #they are the same
    assert_success
}
