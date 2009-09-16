set pagesize 20000

spool alter_pkb_usr.sql

SELECT 'alter PACKAGE '||RPAD(object_name,31,' ')||' compile body;'
  FROM user_objects
 WHERE status <> 'VALID'
   AND object_type = 'PACKAGE BODY'
 ORDER BY object_name
     ;

spool off

set echo on
set timing on
@alter_pkb_usr.sql

