#!/bin/bash

# Test-specific declaro wrapper that uses isolated test environment
# This ensures tests don't depend on system-wide installations

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "$BASH_SOURCE" )" >/dev/null 2>&1 && pwd )"
TEST_ROOT="$( cd "$SCRIPT_DIR/../../.." >/dev/null 2>&1 && pwd )"
TEST_PREFIX="$TEST_ROOT/test_install"

# Set up test environment variables
export ETC_DECLARO_DIR="${ETC_DECLARO_DIR:-"$SCRIPT_DIR/mock_etc_declaro"}"
export DECLAROCONFFILE="${DECLAROCONFFILE:-"$ETC_DECLARO_DIR/config.sh"}"
export KEEPLISTFILE="${KEEPLISTFILE:-"$ETC_DECLARO_DIR/packages.list"}"
export SUDO="${SUDO:-" "}"

# Use test installation paths
export PATH="$TEST_PREFIX/bin:$PATH"

# Run the actual declaro command with test environment
exec "$TEST_PREFIX/bin/declaro" "$@"
