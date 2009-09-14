#!/bin/bash
#
# dump_db.sh
#     dump a mysql database
#
# Para exportar:
#     host origem:
#     $ ./dump_db.sh <dbname> <table>
#
# Para importar:
#     mysql -u root -p -h<destino>
#     sql> \. <file>.dump.sql
#
# Marcus Vinicius Ferreira
# 2008/Nov


mysql_dump() {
    mysqldump -u $DBUSER -p${DBPASS}    \
        --add-drop-table    \
        --add-locks         \
        --all               \
        --create-options    \
        --disable-keys      \
        --extended-insert   \
        --flush-logs        \
        --hex-blob          \
        --quick             \
        --quote-names       \
        $1 $2 > ${DUMP}
}



[ -z "$1" ] && {

    echo
    echo "Usage: $0 dbname <table>"
    echo
    exit 1

}

DBUSER=root
DBPASS=root
  HOST=$( hostname )
  HOST=${HOST%%.*}
    DT=$( /bin/date "+%Y-%m-%d-%H%M")

DB="$1" ; shift

for tab in $@
do
    DUMP="${HOST}_${DB}_${tab}_${DT}.dump.sql"

    echo "Dump: $tab"
    echo
    if mysql_dump $DB $tab
    then gzip -v  $DUMP
    fi
done


