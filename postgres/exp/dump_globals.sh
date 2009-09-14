#!/bin/bash
# $Id: dump_globals.sh 6 2006-09-10 15:35:16Z marcus $
#
# Postgres: dump ddl, data and lobs for all_bases
#
# Marcus Vinicius Ferreira      Dez/2004

usage()
{
cat >&1 <<EOF

    Usage: $0 <pg_data_dir>

EOF
exit 1
}

[ -z $1 ] && usage

FILE=pgdata_`/bin/date +%Y-%m-%d_%H%S`.globals.sql

pg_dumpall          \
    --globals-only  \
    --verbose       > $FILE
