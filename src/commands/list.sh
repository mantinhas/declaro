#!/usr/bin/env bash

SHRBINDIR=$(dirname $BASH_SOURCE)
source $SHRBINDIR/utils.sh

ASSERT_KEEPFILE_EXISTS
parse_keepfile $KEEPLISTFILE

