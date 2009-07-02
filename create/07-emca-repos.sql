
connect "SYS"/"&&sysPassword" as SYSDBA

set echo off
spool /u01/app/oracle/admin/RAC/scripts/emRepository.log

@?/sysman/admin/emdrep/sql/emreposcre ${ORACLE_HOME} SYSMAN &&sysmanPassword TEMP ON;

WHENEVER SQLERROR CONTINUE;

spool off
