connect "SYS"/"&&sysPassword" as SYSDBA

set echo on
spool /u01/app/oracle/admin/RAC/scripts/xdb_protocol.log

@/u01/app/oracle/product/10.2.0/db_1/rdbms/admin/catqm.sql change_on_install SYSAUX TEMP;

connect "SYS"/"&&sysPassword" as SYSDBA
@/u01/app/oracle/product/10.2.0/db_1/rdbms/admin/catxdbj.sql;
@/u01/app/oracle/product/10.2.0/db_1/rdbms/admin/catrul.sql;

spool off
