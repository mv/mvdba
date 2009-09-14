#!/bin/bash
# $Id: dump_ddl.sh 6 2006-09-10 15:35:16Z marcus $
#
# Postgres: dump ddl for all_bases
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

FILE=${1}_`/bin/date +%Y-%m-%d_%H%S`.ddl.sql

pg_dump $1         \
    --file=$FILE   \
    --create       \
    --schema-only  \
    --verbose
