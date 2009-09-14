#!/bin/bash
# $Id$
#
# scp de patches para appdevfs
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

DEST_IP="10.0.61.9"
DEST_USER="appdevfs"
DEST_PATH="/u03/backup/patches_fsw/aplicar_dev2"
DEST="${DEST_USER}@${DEST_IP}:${DEST_PATH}"

echo
echo "Dest: $DEST"
echo

scp $1 $DEST

echo

