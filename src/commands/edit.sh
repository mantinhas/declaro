#!/usr/bin/env bash

SHRBINDIR=$(dirname $BASH_SOURCE)
source $SHRBINDIR/utils.sh

LOAD_DECLAROCONFFILE

if [ -w $KEEPLISTFILE ]; then
    ${VISUAL:-nano} $KEEPLISTFILE
else
    sudoedit $KEEPLISTFILE
fi
