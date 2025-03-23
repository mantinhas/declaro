#!/usr/bin/env bash

SHRDIR=$(dirname $BASH_SOURCE)
source $SHRDIR/utils.sh

function status_aux {
  # Is marked
  if grep -E "^$1$" <($LIST_COMMAND) &>/dev/null; then
    echo "installed: yes"
  else
    echo "installed: no"
  fi

  # Is installed
  if grep -E "^$1$" <(parse_keepfile $KEEPLISTFILE) &>/dev/null; then
    echo "marked: yes"
  else 
    echo "marked: no"
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
    echo "Error: No package specified to check status."
    exit 1
  fi
  status $@
}

main $@
