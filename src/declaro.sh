#!/bin/bash

SHRDIR=$(dirname $BASH_SOURCE)/../share/declaro

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
  echo "  undeclare pkg1 pkg2 ...  [WIP] Undeclare the specified packages, making them removable"
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
      bash $SHRDIR/clean.sh
      ;;
    diff)
      bash $SHRDIR/diff.sh
      ;;
    edit)
      bash $SHRDIR/edit.sh
      ;;
    generate)
      bash $SHRDIR/generate.sh
      ;;
    list)
      bash $SHRDIR/list.sh
      ;;
    status)
      bash $SHRDIR/status.sh $@
      ;;
    declare)
      bash $SHRDIR/declare.sh $@
      ;;
    undeclare)
      #if [[ $# -eq 0 ]]; then
      #    echo "Error: No packages specified to undeclare."
      #    exit 1
      #fi
      echo "Error: Undeclare command is not yet implemented."
      ;;
    --help|-h)
      show_help
      ;;
    *)
      echo "Error: Unknown command '$command'"
      show_help
      exit 1
      ;;
  esac
}

main $@
