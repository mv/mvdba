#!/bin/bash
# $Id: my_dump.sh 6 2006-09-10 15:35:16Z marcus $
#
# Postgres: dump script for a collection of schemas
#
# Marcus Vinicius Ferreira      Dez/2004

usage()
{
cat >&1 <<EOF

    Usage: $0 -force

EOF
exit 1
}

[ -z $1 ] && usage

DT=`/bin/date +%Y-%m-%d_%H%M`
DT=`/bin/date +%Y-%m-%d`

## ----------------------------------------------------------
##
## Customize here!!!!
##

DB_NAME="hughes"
  DB_SCHEMA="public "
  DB_SCHEMA="$DB_SCHEMA exo"
  DB_SCHEMA="$DB_SCHEMA nms"
  DB_SCHEMA="$DB_SCHEMA controle_os"

##
## ----------------------------------------------------------


## Dump dir

[ -d ${DB_NAME}_${DT} ] || mkdir ${DB_NAME}_${DT}
DEPLOY="${DB_NAME}_${DT}/my_deploy.sh"

## Users/Groups

FILE=${DB_NAME}.globals.sql
pg_dumpall -U postgres \
    --globals-only     \
                       > ${DB_NAME}_${DT}/$FILE
#   --verbose          > ${DB_NAME}_${DT}/$FILE

cat > ${DEPLOY} <<CAT
#!/bin/bash
#
# What: Import ${DB_NAME}
# When: $DT
#

psql -U postgres < $FILE


CAT

## Schemas

for SCH in $DB_SCHEMA
do

    echo "   Dump"
    echo "   Dump"
    echo "   Dump: ${DB_NAME}.${SCH} ..."
    echo "   Dump"
    echo "   Dump"
    FILE="${DB_NAME}.${SCH}.sql"
    pg_dump ${DB_NAME}  \
        --file=${DB_NAME}_${DT}/${FILE}    \
        --create        \
        --schema=${SCH} \
        --column-inserts \
#       --verbose

   echo "psql -U postgres < $FILE" >> ${DEPLOY}

done


## Final

cat >> ${DEPLOY} <<CAT

#
# END of script
#

CAT

echo "   Dump"
echo "   Dump"
echo "   Dump Files: `pwd`/${DB_NAME}_${DT} "
echo "   Dump"
echo "   Dump To execute: "
echo "   Dump    $ bash my_deploy.sh"
echo "   Dump"
