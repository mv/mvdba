connect "SYS"/"&&sysPassword" as SYSDBA

set echo on
spool /u01/app/oracle/admin/RAC/scripts/CreateDBCatalog.log

-- dictionary
@?/rdbms/admin/catalog.sql;
-- pl/sql
@?/rdbms/admin/catproc.sql;
-- lock views
@?/rdbms/admin/catblock.sql;
-- crypto
@?/rdbms/admin/catoctk.sql;
-- workspace manager
@?/rdbms/admin/owminst.plb;
-- exp?
-- rman?
-- utlxplan?
-- expceptions?
-- demo?

connect "SYSTEM"/"&&systemPassword"
@/u01/app/oracle/product/10.2.0/db_1/sqlplus/admin/pupbld.sql;

connect "SYSTEM"/"&&systemPassword"

set echo on
spool /u01/app/oracle/admin/RAC/scripts/sqlPlusHelp.log
@/u01/app/oracle/product/10.2.0/db_1/sqlplus/admin/help/hlpbld.sql helpus.sql;

spool off

