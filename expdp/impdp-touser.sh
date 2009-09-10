#!/bin/bash
#
# impdp-touser.sh
#       imp fromuser= touser=
#
# Marcus  Vinicius Ferreira                 ferreira.mv[ at ]gmail.com
# 2009/09
#


[ -z "$2" ] && {
    echo
    echo "Usage: $0  dump_file  fromuser  touser"
    echo
    echo "    Obs: Replacing objects"
    echo
    exit 1
}

[ -z "$CONN" ] && {
    echo "CONN string not defied!"
    exit 2
}

[ -z "$2" ] && {
    echo "fromuser not defied!"
    exit 3
}

[ -z "$3" ] && {
    echo "touser not defied!"
    exit 4
}

export NLS_LANG=AMERICAN_AMERICA.WE8ISO8859P1

dt=$( date "+%Y-%m-%d_%H%M" )

impdp $CONN \
    dumpfile=${1} logfile=impdp_${1}__${dt}.log      \
    remap_schema=$2:$3                  \
    TABLE_EXISTS_ACTION=REPLACE



