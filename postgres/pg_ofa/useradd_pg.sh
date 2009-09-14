# $Id: useradd_pg.sh 6 2006-09-10 15:35:16Z marcus $
#
# postgres
#
# As "root"
#

groupadd -g 600 postgres
groupadd -g 601 dba

useradd -u 600 -g 600 -G dba            \
        -m -d /export/home/postgres     \
        -s /bin/bash                    \
        -c "Postgres User"              \
        -p pg2004 postgres

