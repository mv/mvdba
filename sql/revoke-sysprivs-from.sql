--
--
-- revoke-sysprivs-from.sql
--    revoke system privileges from some GRANTEE
--
-- Usage:
--    @revoke-sysprivs-from.sql GRANTEE
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2009-08
--

SET ECHO OFF
SET FEEDBACK OFF
SET VERIFY OFF
SET TIMING OFF
SET PAGESIZE 0
SET LINESIZE 200

DEFINE _grantee=&&1

-- Grantee exists?
WHENEVER SQLERROR EXIT
    SELECT '-- User: '||username FROM all_users WHERE username = upper('&&_grantee')
    UNION
    SELECT '-- Role: '||role     FROM dba_roles WHERE role     = upper('&&_grantee')
/

WHENEVER SQLERROR CONTINUE

SELECT DISTINCT 'revoke '||RPAD(privilege,40,' ')||' from   '||grantee ||'; '
  FROM dba_sys_privs
 WHERE grantee LIKE UPPER('%&&_grantee%')
 ORDER BY 1
/

SET PAGESIZE 200
SET FEEDBACK ON

