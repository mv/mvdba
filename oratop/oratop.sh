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
    which stty 1>/dev/null && vsize=`stty size|cut -f1 -d" "` || vsize=24
    which stty 1>/dev/null && hsize=`stty size|cut -f2 -d" "` || hsize=80


    sqlplus -s 'mvdba/terra#29@abdps1' <<SQL

        set feedback off
        set linesize 200
        set time off
        set timing off
        exec system.monit.oratop( $hsize, $vsize );

SQL
    echo
    echo "Press CTRL-c to exit"
    sleep 5

done

exit 0


