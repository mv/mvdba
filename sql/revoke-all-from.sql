--
--
-- revoke-all-from.sql
--    revoke full privileges from some GRANTEE given by GRANTOR
--
-- Usage:
--    sqlplus OWNER/pass@bd @ revoke-all-from.sql GRANTEE [grantor]
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
DEFINE _grantor=&&2

-- Grantee exists?
WHENEVER SQLERROR EXIT
    SELECT '-- User: '||username FROM all_users WHERE username = upper('&&_grantee')
    UNION
    SELECT '-- Role: '||role     FROM dba_roles WHERE role     = upper('&&_grantee')
/

WHENEVER SQLERROR CONTINUE

SELECT DISTINCT 'revoke all on '||RPAD(chr(34)||table_name||chr(34),33,' ')||' from &&_grantee ; '
  FROM dba_tab_privs
 WHERE grantor = NVL( UPPER('&&_grantor'), USER)
   AND grantee = UPPER('&&_grantee')
 ORDER BY 1
/

SET PAGESIZE 200
SET FEEDBACK ON

