#!/usr/bin/env bash

SHRBINDIR=$(dirname $BASH_SOURCE)
source $SHRBINDIR/utils.sh

# Validate tarball paths to avoid directory traversal / absolute paths
function validate_tarball_paths {
  local TARFILE="$1"
  local TMP_LIST
  TMP_LIST=$(mktemp -t declaro-tarlist.XXXXXXXX)

  echo "Validating archive contents ..."

  if ! tar tzf "$TARFILE" > "$TMP_LIST"; then
    echo "Error: Failed to list tarball contents." >&2
    rm -f "$TMP_LIST"
    return 1
  fi

  while IFS= read -r ENTRY; do
    if [[ "$ENTRY" == /* || "$ENTRY" == *"../"* ]]; then
      echo "Error: Unsafe path detected inside archive ($ENTRY). Aborting import." >&2
      rm -f "$TMP_LIST"
      return 1
    fi
  done < "$TMP_LIST"

  rm -f "$TMP_LIST"
  return 0
}

function extract_from_source {
  EXTRACTED_SOURCE=$(mktemp -d -t declaro-import.XXXXXXXX)
  trap "rm -rf \"${EXTRACTED_SOURCE}\"" EXIT

  if [[ -f "$1" && $(file "$1") =~ "gzip" ]]; then
    echo "Importing from tarball: $1"

    # Validate archive contents for safe paths before extraction
    if ! validate_tarball_paths "$1"; then
      echo "Error: Tarball path validation failed." >&2
      exit 1
    fi

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
# Validate archive if a .sha256 file is provided or if input is a .tar.gz
  SOURCE_PATH="$1"

  if [[ -f "$SOURCE_PATH" ]] && [[ "$SOURCE_PATH" =~ \.tar\.gz$ ]]; then
    CHECKSUM_FILE="${SOURCE_PATH}.sha256"

    if [[ -f "$CHECKSUM_FILE" ]]; then
      echo "Verifying checksum..."
      if command -v sha256sum &> /dev/null; then
        sha256sum -c "$CHECKSUM_FILE" || { echo "Error: Checksum verification failed." >&2; exit 1; }
      elif command -v shasum &> /dev/null; then
        shasum -a 256 -c "$CHECKSUM_FILE" || { echo "Error: Checksum verification failed." >&2; exit 1; }
      else
        echo "Warning: Could not verify checksum – sha256sum/shasum not found." >&2
      fi
    else
      echo "Warning: No checksum file found alongside archive. Skipping verification." >&2
    fi
  fi

  # Check if something will be overwritten
  if [ "$(ls -A $ETC_DECLARO_DIR)" ]; then
    read -p "This will overwrite your current declared packages and configuration. Consider running 'declaro export' to create a backup first. Proceed? [y/N] " REPLY
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      echo "Operation canceled - no changes were made."
      exit
    fi
  fi
  
  extract_from_source "$SOURCE_PATH"

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
