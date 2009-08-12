--
--
-- grant-exec-to.sql
--    grant execute from schema objects to role/user
--
-- Usage:
--    sqlplus OWNER/pass@bd @ grant-exec-to.sql GRANTEE
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2009-06
--

SET ECHO OFF
SET FEEDBACK OFF
SET VERIFY OFF
SET TIMING OFF
SET PAGESIZE 0
SET LINESIZE 200

DEFINE _grantee=&&1

-- Grantor exists?
WHENEVER SQLERROR EXIT
    SELECT 'User: '||username FROM all_users WHERE username = upper('&&_grantee')
    UNION
    SELECT 'Role: '||role FROM dba_roles WHERE role = upper('&&_grantee')
/

SELECT 'grant execute on '||RPAD(object_name,31,' ')||' to &&_grantee ; -- '||object_type
  FROM user_objects
 WHERE object_type IN ('PROCEDURE','FUNCTION','PACKAGE')
 ORDER BY object_type,1
/

SET PAGESIZE 200
SET FEEDBACK ON
SET ECHO ON

