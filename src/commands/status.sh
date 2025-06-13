#!/usr/bin/env bash

SHRBINDIR=$(dirname $BASH_SOURCE)
source $SHRBINDIR/utils.sh

function status_aux {
  # Is declared
  if grep -E "^$1$" <(LIST_COMMAND) &>/dev/null; then
    echo "installed: yes"
  else
    echo "installed: no"
  fi

  # Is installed
  if grep -E "^$1$" <(parse_keepfile $KEEPLISTFILE) &>/dev/null; then
    echo "declared: yes"
  else 
    echo "declared: no"
  fi
}


function status {
  if (( $# > 1 )); then
    while (( $# > 0 )); do
      echo -e "$1"
      status_aux $1
      shift
    done
  else
    status_aux $1
  fi
}

function main {
  if (( $# == 0 )); then
    echo "Error: No package specified to check status." >&2
    echo "Usage: status <pkg1> [pkg2...]" >&2
    exit 1
  fi
  ASSERT_KEEPFILE_EXISTS
  status $@
}

main $@
