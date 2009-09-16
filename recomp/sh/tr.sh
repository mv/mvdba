sqlplus -s apps/apps <<SQL
set trimspool on

SELECT 'alter TRIGGER '||RPAD(object_name,31,' ')||' compile;'
  FROM user_objects
 WHERE object_type = 'TRIGGER'
   AND status <> 'VALID'
 ORDER BY object_name

spool alter_trg_usr.sql

    set pagesize 20000
    set echo on
    set timing on
    set time on

/

spool off


SQL
