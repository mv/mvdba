#!/bin/bash
#
# imp-touser.sh
#       imp fromuser= touser=
#
# Marcus  Vinicius Ferreira                 ferreira.mv[ at ]gmail.com
# 2008/12
#


[ -z "$2" ] && {
    echo
    echo "Usage: $0 <dump_file> <username>"
    echo
    exit 1
}

[ -z "$CONN" ] && {
    echo "CONN string not defied!"
    exit 2
}

export NLS_LANG=AMERICAN_AMERICA.WE8ISO8859P1

imp $CONN file=${1} log=imp_${1}.log fromuser="$2" touser="$2" ignore=y


