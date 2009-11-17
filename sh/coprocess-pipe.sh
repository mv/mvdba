#!/bin/bash -
#
# coprocess pipe for sqlplus
#     - re-use on single session
#     - Ref: http://laurentschneider.com/wordpress/2009/05/how-to-reuse-connection-in-shell.html
#
# 2009/11

sqlplus -s /nolog |&

print -p "connect scott/tiger"

read -p line
if [ $line != Connected. ]
then
    exit 1
fi

print -p "set feed off head off"

countlines() {
    print -p "select count(*) from $1;"
    read -p c
    echo "there is $c lines in $1"
}

countlines EMP
countlines DEPT

print -p disconnect

