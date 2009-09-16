#!/bin/bash
# $Id: pks.sh 4560 2006-11-23 23:34:30Z marcus.ferreira $
#
# brute force parallel recomp
# Marcus Vinicius Ferreira      ferreira.mv[  at  ]gmail.com
#
# Nov/2006


[ -z "$1" ] && {

cat <<CAT
    Usage: $0 <n>

    <n>: number of objects for each session

CAT
exit 2
}

TP=_pks
SPOOL=alter_${TP}_usr.sql
PARTS="$TP.$$"

sqlplus -s apps/apps <<SQL > $SPOOL

    set trimspool on
    set heading off
    set feedback off
    set pagesize 100

    SELECT 'alter PACKAGE '||RPAD(object_name,31,' ')||' compile;'
      FROM user_objects
     WHERE object_type = 'PACKAGE'
       AND status <> 'VALID'
       AND last_ddl_time < TO_DATE( '2006-11-21','yyyy-mm-dd')
    -- AND object_name LIKE 'PO%'
    -- AND ROWNUM<=50
     ORDER BY object_name
/
SQL

./break.p.sh $TP $SPOOL $PARTS $1

