#!/bin/bash

dbname=rac
dbsid=rac1

export   ORACLE_SID=$dbsid
export  ORACLE_BASE=/u01/app/oracle
export  ORACLE_HOME=${ORACLE_BASE}/product/10.2.0/db_1
export ORACLE_ADMIN=${ORACLE_BASE}/admin
export      SCRIPTS=${ORACLE_ADMIN}/${dbname}/scripts

asm_sys_pass="sys"
 db_sys_pass="sys"
 system_pass="manager"
 sysman_pass="sysman"
 dbsnmp_pass="dbsnmp"

for f in adump bdump cdump udump hdump dbdump pfile create
do
    dir=${ORACLE_ADMIN}/${dbname}/${f}
    mkdir -p         $dir
    chmod 775        $dir
    chown oracle:dba $dir
done; mkdir -p ${ORACLE_HOME}/cfgtoollogs/dbca/${dbname}

echo You should Add this entry in the /etc/oratab:
echo "cat $dbsid:$ORACLE_HOME:Y > /etc/oratab"

orapwd file=${ORACLE_ADMIN}/${dbname}/pfile/orapw${dbsid} password=${db_sys_pass} force=y
ln -s       ${ORACLE_ADMIN}/${dbname}/pfile/orapw${dbsid} ${ORACLE_HOME}/dbs/orapw${dbsid}

echo "SPFILE='+DISKGROUP1/${dbname}/spfile${dbsid}.ora'" >   ${ORACLE_HOME}/dbs/init${dbsid}.ora
ln -s       ${ORACLE_ADMIN}/${dbname}/pfile/init${dbsid}.ora ${ORACLE_HOME}/dbs/init${dbsid}.ora

cd ${SCRIPTS}
sqlplus /nolog
    @ ${SCRIPTS}/${dbsid}.sql

    set verify off
    DEFINE sysPassword = $db_sys_pass
    DEFINE systemPassword = $system_pass
    DEFINE sysmanPassword = $sysman_pass
    DEFINE dbsnmpPassword = $dbsnmp_pass
    DEFINE asmSysPassword = $asm_sys_pass

    @@ CreateDB.sql
    @@ CreateDBFiles.sql
    @@ CreateDBCatalog.sql
    @@ JServer.sql
    @@ xdb_protocol.sql
    @@ ordinst.sql
    @@ interMedia.sql
    @@ emRepository.sql
    @@ CreateClustDBViews.sql

    @@ demobld.sql

    @@ postDBCreation.sql



