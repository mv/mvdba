#!/bin/ksh
#
#

if [ -z "$ORACLE_SID" ]
then
    echo ORACLE_SID not set
    exit 1
fi

 DIR=~/config
CONN=ora-mvdba-abdps1.txt

if [ -z "$1" ]
then connect="${DIR}/${CONN}"
else connect="$1"
fi

###
### one session only: to read and write
###     |& is a ksh feature
sqlplus -s  $( cat $connect ) |&

print -p "set feedback off"
print -p "set serveroutput on size 1000000"
print -p "set linesize 200"
print -p "set time off"
print -p "set timing off"
print -p "exec dbms_application_info.set_module( 'monit', 'oratop');"

while true
do
    # ksh: force integer for arithmetic
    typeset -i vsize
    typeset -i hsize
    which stty 1>/dev/null && vsize=`stty size|cut -f1 -d" "` || vsize=24
    which stty 1>/dev/null && hsize=`stty size|cut -f2 -d" "` || hsize=80

    # send to session
    print -p "exec system.monit.oratop( $hsize, $vsize );"

    # display adjusts
    let vsize=$vsize-2 # offset of bottom messages
    # clear

    # read from session
    for i in {1..$vsize}
    do
        read -p c
        echo "$c"
    done

    # bottom messages
    echo "Press CTRL-c to exit - v: $vsize, h: $hsize"
    sleep 2

done

exit 0


