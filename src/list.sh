#!/usr/bin/env bash

SHRDIR=$(dirname $BASH_SOURCE)
source $SHRDIR/utils.sh

ASSERT_KEEPFILE_EXISTS
parse_keepfile $KEEPLISTFILE

