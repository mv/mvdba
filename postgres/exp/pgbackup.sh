#!/bin/bash
# $Id: pgbackup.sh 6 2006-09-10 15:35:16Z marcus $
#
# Postgres: quick and dirty backup
#
# Marcus Vinicius Ferreira      Dez/2004


export PGDATA=/u01/pgdata
export PGDATABASE=ign_sty
export PATH=/u01/app/postgres/product/7.4.5/bin:/bin:/usr/bin
export LD_LIBRARY_PATH=/u01/app/postgres/product/7.4.5/lib

DT=`/bin/date +%Y-%m-%d`.dump
BKP_DIR=/u01/bkp
BKP_DIR2=/u02/bkp

# ddl + data + lobs
pg_dump ${PGDATABASE}           \
    --file=${BKP_DIR}/${PGDATABASE}_${DT}  \
    --create                    \
    --blobs                     \
    --format=c --compress=9     \
    --verbose

# globals = users + groups
pg_dumpall          \
    --globals-only  \
    --verbose       > ${BKP_DIR}/u01_pgdata_${DT}.globals.sql

# just in case....
/bin/cp ${BKP_DIR}/${PGDATABASE}_${DT}          $BKP_DIR2
/bin/cp ${BKP_DIR}/u01_pgdata_${DT}.globals.sql $BKP_DIR2

# remove oldest
find $BKP_DIR  -type f -mtime +20 -exec /bin/rm {} \;
find $BKP_DIR2 -type f -mtime +20 -exec /bin/rm {} \;
