#!/bin/bash
#
# dump_all.sh
#     dump a mysql database
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
        --all-databases     \
        > ${DUMP}
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
  DUMP="${HOST}_all_${DT}.dump.sql"

if mysql_dump
then gzip -v  $DUMP
fi

