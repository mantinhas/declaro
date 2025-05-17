#!/usr/bin/env bash

SHRBINDIR=$(dirname $BASH_SOURCE)
source $SHRBINDIR/utils.sh

function declare {
  ADDED_MESSAGE="$USER - $(date)"

  if (( $(filter_declaredpkgs $@ | wc -l) > 0 )); then
    echo -e "Packages already declared:\n\t$(filter_declaredpkgs $@ | xargs)"
  fi

  if (( $(filter_undeclaredpkgs $@ | wc -l) > 0 )); then
    echo -e "Declaring packages:\n\t$(filter_undeclaredpkgs $@ | xargs)"
    filter_undeclaredpkgs $@ | sed "s/$/ # $ADDED_MESSAGE/g" | sudo tee -a $KEEPLISTFILE > /dev/null
  else
    echo "No packages to declare."
  fi
}

function main {
  if [[ $# -eq 0 ]]; then
    echo "Error: No packages specified to declare." >&2
    exit 1
  fi
  ASSERT_KEEPFILE_EXISTS
  declare $@
}

main $@
