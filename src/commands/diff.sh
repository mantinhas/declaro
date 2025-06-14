#!/usr/bin/env bash

SHRBINDIR=$(dirname $BASH_SOURCE)
source $SHRBINDIR/utils.sh

ASSERT_KEEPFILE_EXISTS
LOAD_DECLAROCONFFILE
diff_keepfile_installed
