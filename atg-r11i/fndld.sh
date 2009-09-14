#!/bin/sh -x
# $Id$
#
# Execute FNDLOAD depending on file
#
# Marcus Vinicius Ferreira    ferreira.mv[ at ]gmail.com
# Nov/2006
#

usage() {
    cat <<CAT

    Usage: $0 <file> [-s] [-u apps/apps]

        Executes FNDLOAD based on <file>.

    Requires:
        \$FND_TOP    must be set.

    Options:
        -u:         username/password. Default: apps/apps

CAT
#   Options:
#       -s:         use FNDSLOAD instead of FNDLOAD
#       -u:         username/password. Default: apps/apps
exit 2
}

[ -z "$FND_TOP" ] && usage

### Options
[ -z "$1" ]       && usage
 FILE="$1"; shift
 CONN="apps/apps"

for OPT in $@
do
    if [ "$OPT" == "-u" ]
    then
        shift;
        CONN="$1"
        shift;
    else
        usage
    fi

done

### Main
SCRIPT=`grep LDRCONFIG $FILE | awk '{print substr($3,2) }'` # remove {"}
if [ -z "$SCRIPT" ]
then
    if grep "BEGIN MENU" $FILE 2>&1>/dev/null
    then
        SCRIPT="0"
    else
        echo
        echo "Error: cannot find proper script: $FILE"
        echo
        exit 1
    fi
fi


echo "Script: $SCRIPT for $FILE"

if [ "$SCRIPT" ]
then
    FNDLOAD $CONN 0 Y UPLOAD $FND_TOP/patch/115/import/$SCRIPT $FILE
else
    FNDLOAD $CONN 0 Y UPLOAD                                   $FILE
fi

