#!/bin/bash
# $Id$
#
# Marcus Vinicius Ferreira          ferreira.mv[ at ]gmail.com
# Out/2006
#
# adrm.sh
#       rm $MDB_TOP, if needed
#

[ -z "$1" ] && {
    printf "\n\tUsage: $0 <files>\n\n";
    exit 2
}

[ -z "$MDB_TOP" ] && {
    printf "\n\t\$MDB_TOP must be set!!!!\n\n";
    exit 1
}

for f in $@
do
    if [ -f $f ]
    then
        FILE=`find $MDB_TOP $AU_TOP -name ${f##*/} `    # basename
        # info
        ident $f
        [ ! -z $FILE ] && ident $FILE
        echo
    fi

done

for f in $@
do
    if [ -f $f ]
    then    # ${f##*/}
        FILE=`find $MDB_TOP $AU_TOP -name ${f##*/} `
        [ ! -z $FILE ] && echo "    /bin/rm $FILE"
    fi
done
echo


