connect "SYS"/"&&sysPassword" as SYSDBA
set echo on

spool /u01/app/oracle/admin/RAC/scripts/CreateClustDBViews.log
@?/rdbms/admin/catclust.sql;

spool off

