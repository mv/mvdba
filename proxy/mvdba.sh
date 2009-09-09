#!/bin/bash
#
# mvdba.sh
#     shell wrapper for 'mvdba' Oracle proxy user
#     pre-req:
#         alter user USERNAME grant connect through MVDBA;'
#
# Marcus Vinicius Ferreira                          ferreira.mv[ at ]gmail.com
# 2009/09
#

[ -z "$1" ] && {
    echo
    echo "Usage: $0 config.txt [OWNER]"
    echo
    exit 1
}

OWNER="$2"

if which rlwrap > /dev/null
then sql='rlwrap sqlplus -L'
else sql='sqlplus -L'
fi

if [ -z "$OWNER" ]
then
    $sql $( cat $1 )
else
    PROXY=$( cat $1 | awk -F/ '{print $1}' )
     PASS=$( cat $1 | awk -F/ '{print $2}' )

    $sql $PROXY[$OWNER]/$PASS
fi


