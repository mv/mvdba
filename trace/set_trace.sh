#!/bin/bash
# $Id$
# Marcus Vinicius Ferreira          ferreira.mv[ at ]gmail.com
# Fev/2008
#

[ "$2" ] || {

    echo
    echo "    Usage: $0 sid serial# [-d]"
    echo
    echo "        Enable/Disable SQL Trace in sid,serial#"
    echo
    echo "    enable : $0 10 100"
    echo "    disable: $0 10 100 -d"
    echo
    exit 2
}

if [ "$3"  == "-d" ]
then
    cmd="dbms_monitor.session_trace_disable( $1, $2)"
    msg="Disabled"
else
    cmd="dbms_monitor.session_trace_enable ( $1, $2, TRUE, TRUE)"
    msg="Enabled"
fi

sqlplus -s /nolog <<SQL

    connect monitor/monitor@orains01

    set heading off
    SELECT '$msg: sid=$1, serial#=$2 at', TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS')
      FROM dual;

    exec $cmd
    exit

SQL


