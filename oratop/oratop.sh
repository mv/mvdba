#!/bin/bash
#
#

if [ -z "$ORACLE_SID" ]
then
    echo ORACLE_SID not set
    exit 1
fi

 DIR=~/config
CONN=ora_mvdba_abdps1

if [ -z "$1" ]
then connect="${DIR}/${CONN}"
else connect="$1"
fi

while true
do
    clear
    which stty 1>/dev/null && vsize=`stty size|cut -f1 -d" "` || vsize=24
    which stty 1>/dev/null && hsize=`stty size|cut -f2 -d" "` || hsize=80


    sqlplus -s $( cat $connect ) <<SQL

        set feedback off
        set linesize 200
        set time off
        set timing off
        exec dbms_application_info.set_module( 'monit', 'oratop');
        exec system.monit.oratop( $hsize, $vsize );

SQL
    echo
    echo "Press CTRL-c to exit"
    sleep 5

done

exit 0


