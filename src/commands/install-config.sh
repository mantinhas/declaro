#!/bin/bash

# HOTFIX: install.config can be called from make and must be path must be adjusted
SHRBINDIR=${SHRBINDIR:-"$(dirname $BASH_SOURCE)"}
SHRCONFDIR="${SHRBINDIR}/../config"
source $SHRBINDIR/utils.sh

#this command is the only declaro subcommand that can also be called from Makefile
IS_CALLED_AS_SUBCOMMAND=${IS_CALLED_AS_SUBCOMMAND:-"true"}

# 'name              ; requirements for a config_file         ; config_file'
CONFIG_FILE_TABLE=(
  'apt               ; apt --version                          ; apt-config.sh'
  'dnf               ; dnf --version                          ; dnf-config.sh'
  'pacman with paru  ; pacman --version && pacman -Qq paru    ; pacman-paru-config.sh'
  'pacman with yay   ; pacman --version && pacman -Qq yay     ; pacman-yay-config.sh'
  # has to be after paru and yay
  'pacman w/out AUR  ; pacman --version                       ; pacman-config.sh'
)


function detect_and_install_config {
  for CONFIG in "${CONFIG_FILE_TABLE[@]}"; do
    IFS=";" read -r NAME ASSERT CONFFILE <<< "$CONFIG"

    # Remove leading/trailing whitespace
    NAME=$(echo "$NAME" | xargs)
    ASSERT=$(echo "$ASSERT" | xargs) 
    CONFFILE=$(echo "$CONFFILE" | xargs)

    if eval "$ASSERT" 1> /dev/null 2> /dev/null; then
      echo "Detected package manager setup: $NAME"

      echo "Installing config file $CONFFILE..."
      ${SUDO} install -Dm644 "$SHRCONFDIR/$CONFFILE" ${ETC_DECLARO_DIR}/config.sh
      return 0
    fi
  done

  return 1

}

function install-config_as_subcommand {
  # Check if something will be overwritten
  if [ "$(ls -A $ETC_DECLARO_DIR)" ]; then
    read -p "This will overwrite your current declared packages and configuration. Consider running 'declaro export' to create a backup first. Proceed? [y/N] " REPLY
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      echo "Operation canceled - no changes were made."
      exit 0
    fi
  fi

  if detect_and_install_config; then
    ${SUDO} rm $KEEPLISTFILE 2> /dev/null
  else
    echo "Error: declaro does not provide a config file for your distro - configuration was not installed." >&2
    exit 1
  fi
}

function install-config_as_make {
  detect_and_install_config || {
    echo "Warning: declaro does not provide a config file for your distro - configuration was not installed." >&2
    exit 0
  }
}

function install-config {
  if [ "${IS_CALLED_AS_SUBCOMMAND}" = "true" ]; then
    install-config_as_subcommand
  else
    install-config_as_make
  fi
}

install-config
