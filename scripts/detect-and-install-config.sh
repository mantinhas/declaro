#!/bin/bash

ETC_DECLARO_DIR=${ETC_DECLARO_DIR:-"/etc/declaro"}
SUDO=${SUDO:-"sudo"}

# 'name              ; requirements for a config_file         ; config_file'
CONFIG_FILE_TABLE=(
  'apt               ; apt --version                          ; apt-config.sh'
  'pacman with yay   ; pacman --version && pacman -Qq yay     ; pacman-yay-config.sh'
  'pacman w/out AUR  ; pacman --version                       ; pacman-config.sh'
  'dnf               ; dnf --version                          ; dnf-config.sh'
)

for CONFIG in "${CONFIG_FILE_TABLE[@]}"; do
  IFS=";" read -r NAME ASSERT CONFFILE <<< "$CONFIG"

  # Remove leading/trailing whitespace
  NAME=$(echo "$NAME" | xargs)
  ASSERT=$(echo "$ASSERT" | xargs) 
  CONFFILE=$(echo "$CONFFILE" | xargs)

  if eval "$ASSERT" 1> /dev/null 2> /dev/null; then
    echo "Detected package manager setup: $NAME"

    echo "Installing config file $CONFFILE..."
    ${SUDO} install -Dm644 "config/$CONFFILE" ${ETC_DECLARO_DIR}/config.sh
    exit 0
  fi
done

echo "Warning: declaro does not provide a config file for your distro - configuration was not installed." >&2
