#!/bin/bash

# Test-specific install-config script that doesn't depend on system detection
# This allows us to test the install-config functionality without system dependencies

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "$BASH_SOURCE" )" >/dev/null 2>&1 && pwd )"
TEST_ROOT="$( cd "$SCRIPT_DIR/../../.." >/dev/null 2>&1 && pwd )"
TEST_PREFIX="$TEST_ROOT/test_install"

# Use test installation paths
export PATH="$TEST_PREFIX/bin:$PATH"

# Source utils from test installation
source "$TEST_PREFIX/share/declaro/bin/utils.sh"

# Test configuration - we'll simulate different package managers
TEST_PACKAGE_MANAGER=${TEST_PACKAGE_MANAGER:-"apt"}

function detect_and_install_config {
  case "$TEST_PACKAGE_MANAGER" in
    "apt")
      echo "Detected package manager setup: apt"
      echo "Installing config file apt-config.sh..."
      cp "$TEST_PREFIX/share/declaro/config/apt-config.sh" "${ETC_DECLARO_DIR}/config.sh"
      return 0
      ;;
    "dnf")
      echo "Detected package manager setup: dnf"
      echo "Installing config file dnf-config.sh..."
      cp "$TEST_PREFIX/share/declaro/config/dnf-config.sh" "${ETC_DECLARO_DIR}/config.sh"
      return 0
      ;;
    "pacman")
      echo "Detected package manager setup: pacman w/out AUR"
      echo "Installing config file pacman-config.sh..."
      cp "$TEST_PREFIX/share/declaro/config/pacman-config.sh" "${ETC_DECLARO_DIR}/config.sh"
      return 0
      ;;
    "pacman-paru")
      echo "Detected package manager setup: pacman with paru"
      echo "Installing config file pacman-paru-config.sh..."
      cp "$TEST_PREFIX/share/declaro/config/pacman-paru-config.sh" "${ETC_DECLARO_DIR}/config.sh"
      return 0
      ;;
    "pacman-yay")
      echo "Detected package manager setup: pacman with yay"
      echo "Installing config file pacman-yay-config.sh..."
      cp "$TEST_PREFIX/share/declaro/config/pacman-yay-config.sh" "${ETC_DECLARO_DIR}/config.sh"
      return 0
      ;;
    "brew")
      echo "Detected package manager setup: brew"
      echo "Installing config file brew-config.sh..."
      cp "$TEST_PREFIX/share/declaro/config/brew-config.sh" "${ETC_DECLARO_DIR}/config.sh"
      return 0
      ;;
    "none")
      echo "Error: No supported package manager detected"
      return 1
      ;;
    *)
      echo "Error: Unknown test package manager: $TEST_PACKAGE_MANAGER"
      return 1
      ;;
  esac
}

function install-config_as_subcommand {
  # Check if something will be overwritten
  if [ "$(ls -A $ETC_DECLARO_DIR 2>/dev/null)" ]; then
    read -p "This will overwrite your current declared packages and configuration. Consider running 'declaro export' to create a backup first. Proceed? [y/N] " REPLY
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      echo "Operation canceled - no changes were made."
      exit 0
    fi
  fi

  if detect_and_install_config; then
    rm -f "$KEEPLISTFILE" 2> /dev/null
  else
    echo "Error: declaro does not provide a config file for your distro - configuration was not installed." >&2
    exit 1
  fi
}

install-config_as_subcommand
