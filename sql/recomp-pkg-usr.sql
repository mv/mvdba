set pagesize 20000

spool alter_pkg_usr.sql

SELECT 'alter PACKAGE '||RPAD(object_name,31,' ')||' compile;'
  FROM user_objects
 WHERE status <> 'VALID'
   AND object_type = 'PACKAGE'
 ORDER BY object_name
     ;

spool off

set echo on
set timing on
@alter_pkg_usr.sql

