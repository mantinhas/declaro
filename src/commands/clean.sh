#!/usr/bin/env bash

SHRBINDIR=$(dirname $BASH_SOURCE)
source $SHRBINDIR/utils.sh

function clean {
  # Remove packages not in KEEPLISTFILE
  # Save packages list into string, not run command
  STRAY_PKGS=$(get_stray_pkgs | xargs)

  if [[ -n $STRAY_PKGS ]]; then
    echo -e "The following $(echo $STRAY_PKGS | wc -w) package(s) are strayed (installed but not declared in packages.list):\n\t$STRAY_PKGS"
    echo -e "Uninstalling..."
    UNINSTALL_COMMAND $STRAY_PKGS > /dev/null && echo -e "Done."
  else 
    echo "There are no stray packages. Nothing to remove."
  fi

  # Install packages in KEEPLISTFILE
  MISSING_PKGS=$(get_missing_pkgs | xargs)

  if [[ -n $MISSING_PKGS ]]; then
    echo -e "The following $(echo $MISSING_PKGS | wc -w) package(s) are missing (declared in packages.list but not installed):\n\t$MISSING_PKGS"
    echo -e "Installing..."
    INSTALL_COMMAND $MISSING_PKGS > /dev/null && echo -e "Done."
  else
    echo "There are no missing packages. Nothing to install."
  fi

  echo "Cleaning done."
}

function main {
  ASSERT_KEEPFILE_EXISTS
  clean
}

main
