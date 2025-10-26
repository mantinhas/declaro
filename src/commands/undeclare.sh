#!/usr/bin/env bash

SHRBINDIR=$(dirname $BASH_SOURCE)
source $SHRBINDIR/utils.sh

function undeclare {
  # Show already declared packages that will be removed
  if (( $(filter_declaredpkgs $@ | wc -l) > 0 )); then
    echo -e "Removing declarations:\n\t$(filter_declaredpkgs $@ | xargs)"
    for pkg in $(filter_declaredpkgs $@); do
      # delete line starting with package name (optionally followed by spaces and an optional comment)
      ${SUDO} sed -i '' -E "/^${pkg}[[:blank:]]*(#.*)?$/d" "$KEEPLISTFILE"
    done
    return 0
  fi

  # Warn about packages that were not declared
  if (( $(filter_undeclaredpkgs $@ | wc -l) > 0 )); then
    echo -e "Packages not declared:\n\t$(filter_undeclaredpkgs $@ | xargs)"
  fi
}

function main {
  if [[ $# -eq 0 ]]; then
    echo "Error: No packages specified to undeclare." >&2
    echo "Usage: undeclare <pkg1> [pkg2...]" >&2
    exit 1
  fi
  ASSERT_KEEPFILE_EXISTS
  LOAD_DECLAROCONFFILE
  undeclare $@
}

main $@
