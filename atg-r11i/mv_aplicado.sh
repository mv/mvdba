#!/bin/bash
# $Id$
#
# mv para aplicado
#
# (c) Marcus Vinicius Ferreira   ferreira.mv@gmail.com
# Ago/2006

usage() {

    cat <<CAT

    Usage: $0 <file_name>

CAT
    exit 1
}

[ -z "$1" ] && usage

DEST="/u01/patches/aplicado/"

echo
echo "Dest: $DEST"
echo

if [ -d "$DEST/$1" ]
then
    /bin/rm -rf ${DEST}/$1
fi

/bin/mv $1 $DEST

echo

