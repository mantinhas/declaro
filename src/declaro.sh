#!/bin/bash

SHRBINDIR=$(dirname $BASH_SOURCE)/../share/declaro/bin

function show_help {
  echo "Usage: declaro [command] [args]"
  echo "Commands:"
  echo "  clean                    Reset state to declared"
  echo "  diff                     Show diff between declared state and actual state"
  echo "  edit                     Edit the packages.list file"
  echo "  generate                 Generate a new packages.list file"
  echo "  list                     List all declared packages"
  echo "  status pkg1 pkg2 ...     Show the status of a package (is declared and is installed)"
  echo "  declare pkg1 pkg2 ...    Declare the specified packages as permanent"
  echo "  --help, -h               Show this help message"
}

function main {
  if [[ $# -eq 0 ]]; then
    show_help
    exit 0
  fi

  command=$1
  shift

  case $command in
    clean)
      bash $SHRBINDIR/clean.sh
      ;;
    diff)
      bash $SHRBINDIR/diff.sh
      ;;
    edit)
      bash $SHRBINDIR/edit.sh
      ;;
    generate)
      bash $SHRBINDIR/generate.sh
      ;;
    list)
      bash $SHRBINDIR/list.sh
      ;;
    status)
      bash $SHRBINDIR/status.sh $@
      ;;
    declare)
      bash $SHRBINDIR/declare.sh $@
      ;;
    --help|-h)
      show_help
      ;;
    *)
      echo "Error: Unknown command '$command'" >&2
      show_help
      exit 1
      ;;
  esac
}

main $@
