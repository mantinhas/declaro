#!/usr/bin/env bash

SHRBINDIR=$(dirname $BASH_SOURCE)
source $SHRBINDIR/utils.sh

function extract_from_source {
  EXTRACTED_SOURCE=$(mktemp -d -t declaro-import.XXXXXXXX)
  #trap "rm -rf \"${EXTRACTED_SOURCE}\"" EXIT

  if [[ -f "$1" && $(file "$1") =~ "gzip" ]]; then
    echo "Importing from tarball: $1"
    tar xzf "$1" --directory="${EXTRACTED_SOURCE}" || {
      echo "Error: Failed to extract tar.gz file." >&2
      exit 1
    }

  elif git ls-remote "$1" 1> /dev/null 2> /dev/null ; then
    echo "Importing from Git repository: $1"
    git clone "$1" "${EXTRACTED_SOURCE}" || {
      echo "Error: Failed to clone Git repository." >&2
      exit 1
    }

  else
    echo "Error: Invalid source format. Must be a .tar.gz file or a Git repository URL." >&2
    echo "Usage: declaro import <source>" >&2
    exit 1
  fi
}

function import {
  # Check if something will be overwritten
  if [ "$(ls -A $ETC_DECLARO_DIR)" ]; then
    read -p "This will overwrite your current declared packages and configuration. Consider running 'declaro export' to create a backup first. Proceed? [y/N] " REPLY
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      exit
    fi
  fi

  extract_from_source "$1"

  ${SUDO} cp -r ${EXTRACTED_SOURCE}/* $ETC_DECLARO_DIR
  echo -e "New packages.list:\n\t$(parse_keepfile $KEEPLISTFILE | xargs) "

  echo "Done."
}

function main {
  if [ -z "$1" ]; then
    echo "Error: No source specified." >&2
    echo "Usage: declaro import <source>" >&2
    exit 1
  fi

  import "$1"
}

main $@
