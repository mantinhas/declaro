#!/usr/bin/env bash

SHRDIR=$(dirname $BASH_SOURCE)
source $SHRDIR/utils.sh

ASSERT_KEEPFILE_EXISTS
diff_keepfile_installed
