#!/bin/bash
#
#

if [ -z "$ORACLE_SID" ]
then
    echo ORACLE_SID not set
    exit 1
fi

while true
do
    clear
    hsize=`stty size|cut -f2 -d" "`
    vsize=`stty size|cut -f1 -d" "`

    sqlplus -s system/sys@orcl <<SQL

        set feedback off
        set linesize 200
        exec system.monit.oratop( $hsize, $vsize );

SQL

    echo
    echo "Press CTRL-c to exit"
    sleep 5

done

exit 0


