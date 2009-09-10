#!/bin/bash
#
# impdp.sh
#       impdp com REPLACE
#
# Marcus  Vinicius Ferreira                 ferreira.mv[ at ]gmail.com
# 2009/09
#


[ -z "$1" ] && {
    echo
    echo "Usage: $0  dump_file"
    echo
    echo "    Obs: Replacing objects"
    echo
    exit 1
}

[ -z "$CONN" ] && {
    echo "CONN string not defied!"
    exit 2
}

export NLS_LANG=AMERICAN_AMERICA.WE8ISO8859P1

dt=$( date "+%Y-%m-%d_%H%M" )

impdp $CONN \
    dumpfile=${1} logfile=impdp_${1}__${dt}.log      \
    TABLE_EXISTS_ACTION=REPLACE



