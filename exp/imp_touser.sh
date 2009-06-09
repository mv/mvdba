#!/bin/bash
#
# imp_touser.sh
#       imp fromuser= touser=
#
# Marcus  Vinicius Ferreira                 ferreira.mv[ at ]gmail.com
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

imp $CONN file=${1} log=imp_${1}.log fromuser="$2" touser="$2" ignore=y


