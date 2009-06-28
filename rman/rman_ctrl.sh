#!/bin/bash
#
# Basic full backup
#     
# Marcus Vinicius Ferreira                  ferreira.mv[ at ]gmail.com
# 2009/Jun
#

# set: ORACLE_HOME
#      ORACLE_SID
#      PATH,CONFIG,MAIL_TO
source /u01/app/oracle/config/env-ora.sh

DIR=/mnt/rman
DST=${DIR}/$( date '+%Y-%m-%d' )
LOG=${ORACLE_BASE}/log/rman_full.log

[ ! -d $DST ] && mkdir -p $DST

exec 1>>$LOG
exec 2>>$LOG

_format="${DST}/%d_%I_%Y-%M-%D_set-%s-%p-%c"

time rman $( cat $CONFIG/rman_target_${ORACLE_SID}.txt ) <<RMAN

run {
    # %d: db name
    # %I: dbid: a different id between clones of a same db
    # %s-%p-%c: "set-piece-copynumber"

    sql 'alter system archive log current';

    allocate channel t2 type disk format '${_format}_ctrl.rman' maxpiecesize 4G ;
    backup 
        tag 'CONTROLFILE' current controlfile;
    release channel t2;

    sql 'alter system archive log current';
}

exit

RMAN


