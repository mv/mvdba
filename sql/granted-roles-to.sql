--
--
-- granted-roles-to.sql
--    show grants given by some user
--
-- Usage:
--     SQL> @granted-roles-to         -- all users
--     SQL> @granted-roles-to scott   -- privileges given by SCOTT
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

column object_name  format a40
column comments     format a40
column privilege    format a30

SELECT 'grant '||granted_role
     , 'to '||grantee                                   grantee
     , decode(admin_option,'YES','with admin option','                 ')
     ||' -- default? ; '||default_role                  comments
  FROM dba_role_privs
 WHERE grantee = NVL( UPPER('&&1'), grantee)
 ORDER BY 1
/

SET FEEDBACK ON
SET VERIFY   ON


