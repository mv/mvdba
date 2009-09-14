#!/bin/bash
# $Id: dump_data.sh 6 2006-09-10 15:35:16Z marcus $
#
# Postgres: dump data only for all_bases
#
# Marcus Vinicius Ferreira      Dez/2004

usage()
{
cat >&1 <<EOF

    Usage: $0 <dbname>

EOF
exit 1
}

[ -z $1 ] && usage

FILE=${1}_`/bin/date +%Y-%m-%d_%H%S`.data.sql

pg_dump $1          \
    --file=$FILE    \
    --create        \
    --data-only     \
    --verbose
