#!/usr/bin/env bash

SHRBINDIR=$(dirname $BASH_SOURCE)
source $SHRBINDIR/utils.sh

function generate {

  # If file does not exist, create it and parent directories
  if [ ! -f $KEEPLISTFILE ]; then
    mkdir -p $(dirname $KEEPLISTFILE)
    ${SUDO} touch $KEEPLISTFILE
  fi

  # Check if file has contents
  if [ -s $KEEPLISTFILE ]; then
    # Request user confirmation
    read -p "File $KEEPLISTFILE already exists. Do you want to overwrite it? [y/N] " REPLY
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      echo "Operation canceled - no changes were made."
      exit
    fi
  fi

  echo -e "Generating new packages.list file containing $(LIST_COMMAND | wc -l) packages:\n\t$(LIST_COMMAND | tr '\n' ' ')"
  echo "# Packages list generated on $(date)" | ${SUDO} tee $KEEPLISTFILE > /dev/null
  LIST_COMMAND | ${SUDO} tee -a $KEEPLISTFILE > /dev/null
}

LOAD_DECLAROCONFFILE
generate $@
