#!/bin/bash
#
# expdp-table-data.sh
#       one table, data only
#
# Marcus Vinicius Ferreira                 ferreira.mv[ at ]gmail.com
# 2009/09
#


[ -z "$1" ] && {

    echo
    echo "Usage: $0  file_name  owner.table[:partition]"
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

expdp $CONN \
    content=DATA_ONLY \
    dumpfile=${file}.dmp logfile=expdp_${file}.log  \
    tables=$2

#   content=ALL exclude=GRANT exclude=INDEX exclude=CONSTRAINT exclude=TRIGGER

