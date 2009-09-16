#!/bin/bash

if [ -z "$1" ]
then
    echo
    echo "Usage $0 <os pid>
    echo
    exit 1
fi

CMD = `ps -ef | grep -v grep | grep $1 | awk '{ print $8 }'`
DBNAME = ${CMD:7:xx}

echo "CMD [ $CMD ], DBNAME [ $DBNAME ] "
exit

sqlplus system/\$w6w53j@${DBNAME} <<SQL
    SELECT ses.username
         , ses.sid
         , ses.serial#
         , ses.process
         , prc.spid
         , ses.program
         , ses.terminal
         , sql_text
      FROM v$sqltext_with_newlines  sql
         , v$session                ses
         , v$process                prc
     WHERE sql.address      = ses.sql_address
       AND sql.hash_value   = ses.sql_hash_value
       AND ses.paddr        = prc.addr
       AND spid = &1
    /

    exit
SQL

