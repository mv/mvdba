# $Id: mkdir_pg_ofa.sh 6 2006-09-10 15:35:16Z marcus $
#
# pg 7.4.x
#
# As "root"
#


RELEASE=7.4.7
PGBASE=/u01/app/postgres
PGHOME=${PGBASE}/product/${RELEASE}

mkdir -p ${PGBASE}
mkdir -p ${PGBASE}/admin/dbname/conf
mkdir -p ${PGBASE}/admin/dbname/exp
mkdir -p ${PGBASE}/admin/dbname/repl
mkdir -p ${PGBASE}/admin/dbname/sql
mkdir -p ${PGHOME}

chown -R postgres:dba ${PGBASE}
chmod -R 0775         ${PGBASE}


mkdir -p /u01/pgdata/log
chown -R postgres:postgres  /u01/pgdata
chmod -R 0700               /u01/pgdata
chmod -R 0755               /u01/pgdata/log


