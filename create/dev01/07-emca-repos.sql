
connect "SYS"/"&&sysPassword" as SYSDBA

set echo off
spool /u01/app/oracle/admin/dev01/scripts/emRepository.log

@?/sysman/admin/emdrep/sql/emreposcre ${Odev01LE_HOME} SYSMAN &&sysmanPassword TEMP ON;

WHENEVER SQLERROR CONTINUE;

spool off


