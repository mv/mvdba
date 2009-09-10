#!/bin/bash
#
# exp-owner.sh
#       export an owner: data et al
#
# Marcus Vinicius Ferreira                 ferreira.mv[ at ]gmail.com
# 2008/12
#


[ -z "$1" ] && {

    echo
    echo "Usage: $0 <owner>"
    echo
    exit 1
}

[ -z "$CONN" ] && {
    echo "CONN string not defied!"
    exit 2
}

export NLS_LANG=AMERICAN_AMERICA.WE8ISO8859P1

  dt=$( date "+%Y-%m-%d_%H%M" )
file=${1}_${dt}

if exp $CONN \
        rows=Y grants=Y indexes=Y constraints=Y triggers=Y  \
        direct=y buffer=10000000 RECORDLENGTH=65535         \
        compress=n statistics=none                          \
        file=${file}.dmp log=exp_${file}.log                \
        owner=$1
then
    echo
    echo "Compress..."
    gzip -v ${file}.dmp
fi


