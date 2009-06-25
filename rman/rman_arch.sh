#!/bin/bash
#
# Basic full backup
#     
# Marcus Vinicius Ferreira                  ferreira.mv[ at ]gmail.com
# 2009/Jun
#

source /u01/app/oracle/config/env-ora-10.2.0.sh

DIR=/mnt/rman
DST=${DIR}/$( /bin/date '+%Y-%m-%d' )
LOG=${ORACLE_BASE}/log/rman_full.log

[ ! -d $DST ] && mkdir -p $DST

exec 1>>$LOG
exec 2>>$LOG

time rman $( cat /u01/app/oracle/config/rman_target_${ORACLE_SID}.txt ) <<RMAN

run {
    # %d: db name
    # %I: dbid: diferencia entre clones do mesmo db
    # %s-%p-%c: "set-piece-copynumber"

    sql 'alter system archive log current';

    allocate channel t3 type disk format '${DST}/%d_%I_%Y-%M-%D_set-%s-%p-%c_arch.rman' maxpiecesize 4G ;
    backup as compressed backupset 
        tag 'ARCHIVE' ( ARCHIVELOG ALL SKIP INACCESSIBLE NOT BACKED UP ) ;
    release channel t3;
}

exit

RMAN

