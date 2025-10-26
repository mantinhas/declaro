#!/usr/bin/env bash

SHRBINDIR=$(dirname $BASH_SOURCE)
source $SHRBINDIR/utils.sh

if [ -z "$1" ]; then
  echo "Error: No output file specified." >&2
  echo "Usage: declaro export <file>" >&2
  exit 1
fi

# Create tarball and generate checksum next to it
TARBALL_PATH="$1"

# Ensure the output has .tar.gz extension – if not, append it for clarity
if [[ ! "$TARBALL_PATH" =~ \.tar\.gz$ ]]; then
  TARBALL_PATH="${TARBALL_PATH}.tar.gz"
fi

echo "Creating archive $TARBALL_PATH ..."
tar czf "$TARBALL_PATH" --directory="${ETC_DECLARO_DIR}" . || {
  echo "Error: Failed to create tarball." >&2
  exit 1
}

echo "Generating SHA-256 checksum ..."
if command -v sha256sum &> /dev/null; then
  sha256sum "$TARBALL_PATH" > "${TARBALL_PATH}.sha256"
elif command -v shasum &> /dev/null; then
  shasum -a 256 "$TARBALL_PATH" > "${TARBALL_PATH}.sha256"
else
  echo "Warning: Could not find sha256sum or shasum. Checksum file was not generated." >&2
fi

echo "Export completed: $TARBALL_PATH (and checksum)"
