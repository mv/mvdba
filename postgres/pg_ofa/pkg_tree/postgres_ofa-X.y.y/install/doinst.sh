
## by mvf

groupadd -g 600 postgres 2> /dev/null
useradd -u 600 -g 600 -m -s /bin/bash \
        -d /export/home/postgres      \
        -c "Postgres User" -p pg2004  \
        postgres 2> /dev/null

[ -f /var/opt/postgres/pgtab ] || /bin/mv /var/opt/pgsql/pgtab.new  /var/opt/pgsql/pgtab
[ -f ~postgres/.profile   ] || /bin/cp ~postgres/home.profile.sh ~postgres/.profile
[ -f ~postgres/.bashrc    ] || /bin/cp ~postgres/home.bashrc.sh  ~postgres/.bashrc 
[ -f ~postgres/.psqlrc    ] || /bin/cp ~postgres/home.psqlrc     ~postgres/.psqlrc 

chown -R postgres:postgres ~postgres

## Generated:

( cd u01/app/postgres/product/7.4.7/bin ; rm -rf postmaster )
( cd u01/app/postgres/product/7.4.7/bin ; ln -sf postgres postmaster )
( cd u01/app/postgres/product/7.4.7/lib ; rm -rf libpq.so.3 )
( cd u01/app/postgres/product/7.4.7/lib ; ln -sf libpq.so.3.1 libpq.so.3 )
( cd u01/app/postgres/product/7.4.7/lib ; rm -rf libpq.so )
( cd u01/app/postgres/product/7.4.7/lib ; ln -sf libpq.so.3.1 libpq.so )
( cd u01/app/postgres/product/7.4.7/lib ; rm -rf libecpg.so.4 )
( cd u01/app/postgres/product/7.4.7/lib ; ln -sf libecpg.so.4.1 libecpg.so.4 )
( cd u01/app/postgres/product/7.4.7/lib ; rm -rf libpgtypes.so.1 )
( cd u01/app/postgres/product/7.4.7/lib ; ln -sf libpgtypes.so.1.2 libpgtypes.so.1 )
( cd u01/app/postgres/product/7.4.7/lib ; rm -rf libpgtypes.so )
( cd u01/app/postgres/product/7.4.7/lib ; ln -sf libpgtypes.so.1.2 libpgtypes.so )
( cd u01/app/postgres/product/7.4.7/lib ; rm -rf libecpg.so )
( cd u01/app/postgres/product/7.4.7/lib ; ln -sf libecpg.so.4.1 libecpg.so )
( cd u01/app/postgres/product/7.4.7/lib ; rm -rf libpgtcl.so )
( cd u01/app/postgres/product/7.4.7/lib ; ln -sf libpgtcl.so.2.4 libpgtcl.so )
( cd u01/app/postgres/product/7.4.7/lib ; rm -rf libecpg_compat.so.1 )
( cd u01/app/postgres/product/7.4.7/lib ; ln -sf libecpg_compat.so.1.2 libecpg_compat.so.1 )
( cd u01/app/postgres/product/7.4.7/lib ; rm -rf libecpg_compat.so )
( cd u01/app/postgres/product/7.4.7/lib ; ln -sf libecpg_compat.so.1.2 libecpg_compat.so )
( cd u01/app/postgres/product/7.4.7/lib ; rm -rf libpgtcl.so.2 )
( cd u01/app/postgres/product/7.4.7/lib ; ln -sf libpgtcl.so.2.4 libpgtcl.so.2 )


## by mvf

( cd usr/local/bin ; rm -rf pghome.sh )
( cd usr/local/bin ; ln -sf ../../../export/home/postgres/bin/pghome.sh pghome.sh )
( cd usr/local/bin ; rm -rf pgofa.sh )
( cd usr/local/bin ; ln -sf ../../../export/home/postgres/bin/pgofa.sh pgofa.sh )

chown -R postgres:postgres u01/app/postgres/product/7.4.5

