#!/bin/bash

SHRBINDIR=$(dirname $BASH_SOURCE)/../share/declaro/bin

function show_help {
  echo "Usage: declaro [command] [args]"
  echo "Commands:"
  echo "  install-config             Detect and install correct configuration for your package manager"
  echo "  clean                      Reset state to declared"
  echo "  declare <pkg1> [pkg2...]   Declare the specified packages as permanent"
  echo "  undeclare <pkg1> [pkg2...] Remove the specified packages from declaration"
  echo "  diff                       Show diff between declared state and actual state"
  echo "  edit                       Edit the packages.list file in your default editor (\$VISUAL)"
  echo "  export <file>              Export the configurations and packages list to a tar.gz file"
  echo "  generate                   Generate a new packages.list file"
  echo "  import <source>            Import a declared state from a .tar.gz file or Git repository"
  echo "  list                       List all declared packages"
  echo "  status <pkg1> [pkg2...]    Show the status of a package (is declared and is installed)"
  echo "  --help, -h                 Show this help message"
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
    undeclare)
      bash $SHRBINDIR/undeclare.sh $@
      ;;
    export)
      bash $SHRBINDIR/export.sh $1
      ;;
    import)
      bash $SHRBINDIR/import.sh $1
      ;;
    "install-config")
      bash $SHRBINDIR/install-config.sh
      ;;
    "--help"|-h)
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
