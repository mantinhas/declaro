#!/usr/bin/env bash

SHRDIR=$(dirname $BASH_SOURCE)
source $SHRDIR/utils.sh

function generate {

  # If file does not exist, create it and parent directories
  if [ ! -f $KEEPLISTFILE ]; then
    mkdir -p $(dirname $KEEPLISTFILE)
    touch $KEEPLISTFILE
  fi

  # Check if file has contents
  if [ -s $KEEPLISTFILE ]; then
    # Request user confirmation
    read -p "File $KEEPLISTFILE already exists. Do you want to overwrite it? [y/N] " REPLY
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      exit
    fi
  fi

  echo -e "Generating new packages.list file containing $(pacman -Qqe | wc -l) packages:\n\t$(pacman -Qqe | tr '\n' ' ')"
  echo "# Packages list generated on $(date)" > $KEEPLISTFILE
  pacman -Qqe >> $KEEPLISTFILE
}

generate $@
