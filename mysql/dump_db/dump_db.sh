#!/bin/bash
#
# dump_db.sh
#     dump a mysql database
#
# Para exportar:
#     host origem:
#     $ ./dump_db.sh <dbname>
#
# Para importar:
#     mysql -u root -p -h<destino>
#     sql> create database <new_database>;
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
        $1 > ${DUMP}
}



[ -z "$1" ] && {

    echo
    echo "Usage: $0 dbname"
    echo
    exit 1

}

DBUSER=root
DBPASS=root
  HOST=$( hostname )
  HOST=${HOST%%.*}
    DT=$( /bin/date "+%Y-%m-%d-%H%M")
  DUMP="${HOST}_${1}_${DT}.dump.sql"

if mysql_dump $1
then gzip -v  $DUMP
fi

