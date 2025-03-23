#!/usr/bin/env bash

SHRDIR=$(dirname $BASH_SOURCE)
source $SHRDIR/utils.sh

function mark {
  ADDED_MESSAGE="$USER - $(date)"

  if (( $(filter_markedpkgs $@ | wc -l) > 0 )); then
    echo -e "Packages already marked:\n\t$(filter_markedpkgs $@ | xargs)"
  fi

  if (( $(filter_unmarkedpkgs $@ | wc -l) > 0 )); then
    echo -e "Marking packages:\n\t$(filter_unmarkedpkgs $@ | xargs)"
    filter_unmarkedpkgs $@ | sed "s/$/ # $ADDED_MESSAGE/g" >> $KEEPLISTFILE
  else
    echo "No packages to mark."
  fi
}

function main {
  if [[ $# -eq 0 ]]; then
    echo "Error: No packages specified to mark."
    exit 1
  fi
  mark $@
}

main $@
