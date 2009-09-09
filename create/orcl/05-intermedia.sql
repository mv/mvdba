connect "SYS"/"&&sysPassword" as SYSDBA
set echo on

spool /u01/app/oracle/admin/RAC/scripts/ordinst.log

@?/ord/admin/ordinst.sql SYSAUX SYSAUX;
@?/ord/im/admin/iminst.sql;

spool off

