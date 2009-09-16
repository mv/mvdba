sqlplus -s apps/apps <<SQL
set trimspool on

SELECT 'alter PACKAGE '||RPAD(object_name,31,' ')||' compile BODY;'
  FROM user_objects
 WHERE object_type = 'PACKAGE BODY'
-- AND status <> 'VALID'
 ORDER BY object_name

spool alter_pkb_usr.sql

    set pagesize 20000
    set echo on
    set timing on
    set time on

/

spool off


SQL
