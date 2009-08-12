--
--
-- AbrilDigital
--    grant access from schema objects to connect user
--
-- Usage:
--    sqlplus OWNER/pass@bd @ grant-to-user.sql CONNECT_USER
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2009-06
--

SET PAGESIZE 0
SET LINESIZE 200
SET FEEDBACK OFF
SET VERIFY OFF

DEFINE _user=&&1

-- Grantor exists?
WHENEVER SQLERROR EXIT
    SELECT 'User: '||username FROM all_users WHERE username = upper('&&_user')
    UNION
    SELECT 'Role: '||role FROM dba_roles WHERE role = upper('&&_user')
/

spool grant.sql

SELECT 'grant select  on '||RPAD(object_name,31,' ')||' to &&_user ;'
  FROM user_objects
 WHERE object_type IN ('VIEW','SEQUENCE')
 ORDER BY object_type,1
/

SELECT 'grant execute on '||RPAD(object_name,31,' ')||' to &&_user ;'
  FROM user_objects
 WHERE object_type IN ('PROCEDURE','FUNCTION','PACKAGE')
 ORDER BY object_type,1
/

SELECT 'grant select,insert,update,delete,references,index on '||RPAD(table_name,31,' ')||' to &&_user ;'
  FROM user_tables
 ORDER BY 1
/

spool off

SET PAGESIZE 200
SET FEEDBACK ON
SET ECHO ON

