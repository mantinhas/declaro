#!/bin/bash

SHRDIR=$(dirname $BASH_SOURCE)/../share/pacmark

function show_help {
  echo "Usage: pacmark [command] [args]"
  echo "Commands:"
  echo "  clean                 Reset state to declared"
  echo "  diff                  Show diff between declared state and actual state"
  echo "  edit                  Edit the packages.list file"
  echo "  generate              Generate a new packages.list file"
  echo "  list                  List all marked (declared) packages"
  echo "  status pkg1 pkg2 ...  Show the status of a package (marked, installed, or both)"
  echo "  mark pkg1 pkg2 ...    Mark the specified packages as permanent"
  echo "  unmark pkg1 pkg2 ...  [WIP] Unmark the specified packages, making them removable"
  echo "  --help, -h            Show this help message"
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
      $EDITOR $KEEPLISTFILE
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
    mark)
      bash $SHRDIR/mark.sh $@
      ;;
    unmark)
      #if [[ $# -eq 0 ]]; then
      #    echo "Error: No packages specified to unmark."
      #    exit 1
      #fi
      #source ~/.local/lib/pacmark/mark.sh 
      #unmark $@
      echo "Error: Unmark command is not yet implemented."
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
