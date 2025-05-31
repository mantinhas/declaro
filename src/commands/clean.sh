#!/usr/bin/env bash

SHRBINDIR=$(dirname $BASH_SOURCE)
source $SHRBINDIR/utils.sh
RETURN_CODE=0

function remove_stray {
  # Remove packages not in KEEPLISTFILE
  echo -e "(1/2) Removing stray packages\n"

  # Save packages list into string, not run command
  STRAY_PKGS=$(get_stray_pkgs | xargs)

  if [[ -n $STRAY_PKGS ]]; then
    echo -e "The following $(echo $STRAY_PKGS | wc -w) package(s) are strayed (installed but not declared in packages.list):\n\t$STRAY_PKGS"
    echo -e "Uninstalling..."
    

    OUTPUT="$(UNINSTALL_COMMAND $STRAY_PKGS 2>&1)"
    STATUS=$?

    if [[ $STATUS -ne 0 ]]; then
      echo -e "Manual intervention required. There was an error while uninstalling:\n"
      echo -e "=== START OUTPUT ===\n$OUTPUT\n=== END OUTPUT ==="
      RETURN_CODE=1
    else
      echo -e "Done."
    fi

  else 
    echo "There are no stray packages. Nothing to remove."
  fi
}

function install_missing {
  # Install packages in KEEPLISTFILE
  echo -e "(2/2) Installing missing packages\n"

  MISSING_PKGS=$(get_missing_pkgs | xargs)

  if [[ -n $MISSING_PKGS ]]; then
    echo -e "The following $(echo $MISSING_PKGS | wc -w) package(s) are missing (declared in packages.list but not installed):\n\t$MISSING_PKGS"
    echo -e "Installing..."

    OUTPUT="$(INSTALL_COMMAND $MISSING_PKGS 2>&1)"
    STATUS=$?

    if [[ $STATUS -ne 0 ]]; then
      echo -e "Manual intervention required. There was an error while installing:\n"
      echo -e "=== START OUTPUT ===\n$OUTPUT\n=== END OUTPUT ==="
      RETURN_CODE=1
    else
      echo -e "Done."
    fi

  else
    echo "There are no missing packages. Nothing to install."
  fi
}

function main {
  ASSERT_KEEPFILE_EXISTS
  remove_stray
  printf "\n"
  install_missing
  return $RETURN_CODE
}

main
