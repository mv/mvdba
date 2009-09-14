# $Id: build_pg_ofa.sh 6 2006-09-10 15:35:16Z marcus $
#
# pg 7.4.x
#
# executar como "postgres" shell
#

DT_INST=`/bin/date +%Y-%m-%d-%H:%M`

RELEASE=7.4.7
PGBASE=/u01/app/postgres
PGHOME=${PGBASE}/product/${RELEASE}

CC=gcc CFLAGS="-O2"                     \
    ./configure                         \
        --prefix=$PGHOME                \
        --with-tcl                      \
        --with-perl                     \
        --with-python                   \
        --with-java                     \
        --with-openssl                  \
        | tee configure.log_${DT_INST}

    make | tee make.log_${DT_INST}
    make install | tee make_install.log_${DT_INST}

cd contrib/dblink
    make
    make install
    cd ../..

cd contrib/dbsize
    make
    make install
    cd ../..

cd contrib/oid2name
    make
    make install
    cd ../..

