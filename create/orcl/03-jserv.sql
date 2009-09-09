
connect "SYS"/"&&sysPassword" as SYSDBA

set echo on
spool /u01/app/oracle/admin/RAC/scripts/JServer.log

@?/javavm/install/initjvm.sql;
@?/xdk/admin/initxml.sql;
@?/xdk/admin/xmlja.sql;
@?/rdbms/admin/catjava.sql;
@?/rdbms/admin/catexf.sql;

spool off


