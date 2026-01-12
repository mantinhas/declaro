#!/usr/bin/env bash

SHRBINDIR=$(dirname $BASH_SOURCE)
source $SHRBINDIR/utils.sh

LOAD_DECLAROCONFFILE
ASSERT_KEEPFILE_EXISTS
diff_keepfile_installed