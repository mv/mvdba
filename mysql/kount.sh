#!/bin/bash
#
# mysql count tables
#
# Marcus Vinicius Ferreira                          ferreira.mv[ at ]gmail.com
# 2009/12

[ -z "$1" ] && {

    echo
    echo "Usage: $0 dbname"
    echo
    exit 1
}

dbname="$1"

mysql -B -N -e "SHOW TABLES" $dbname    \
| sort \
| awk '{print "select '"'"'" $1 "'"'"', count(*) as qtd from ", $1, ";"}'    \
| mysql  -N                  $dbname    \
| column -t


