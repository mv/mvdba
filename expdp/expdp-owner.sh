#!/bin/bash
#
# expdp-owner.sh
#       export an owner: data et al
#
# Marcus Vinicius Ferreira                 ferreira.mv[ at ]gmail.com
# 2009/09
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

expdp $CONN \
    dumpfile=${file}.dmp logfile=expdp_${file}.log  \
    schemas=$1


