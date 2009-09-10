#!/bin/bash
#
# exp-table-data.sh
#       one table, data only
#
# Marcus  Vinicius Ferreira                 ferreira.mv[ at ]gmail.com
# 2008/12
#


[ -z "$1" ] && {

    echo
    echo "Usage: $0  dump_file  owner.table_name"
    echo
    exit 1
}

[ -z "$CONN" ] && {
    echo "CONN string not defied!"
    exit 2
}

[ -z "$2" ] && {
    echo "OWNER.TABLE_NAME must be defied!"
    exit 3
}

export NLS_LANG=AMERICAN_AMERICA.WE8ISO8859P1

  dt=$( date "+%Y-%m-%d_%H%M" )
file=${1}_${dt}

if exp $CONN \
        rows=Y grants=N indexes=N constraints=N     \
        direct=y buffer=10000000 RECORDLENGTH=65535 \
        compress=n statistics=none                  \
        file=${file}.dmp log=exp_${file}.log        \
        tables= \( $2 \)
then
    echo
    echo "Compress..."
    gzip -v ${file}.dmp
fi


