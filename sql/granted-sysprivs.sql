--
--
-- granted-sysprivs.sql
--    show system privileges given to some user
--
-- Usage:
--     SQL> @granted-sysprivs         -- all users
--     SQL> @granted-sysprivs scott   -- privileges given by SCOTT
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

column object_name  format a40
column comments     format a40
column privilege    format a30

SELECT 'grant '||privilege                              privilege
     , 'to '||grantee                                   grantee
     , decode(admin_option,'YES','with admin option','')
     ||';'                                              comments
  FROM dba_sys_privs
 WHERE grantee LIKE UPPER('%&&1%')
 ORDER BY 2,1
/

SET FEEDBACK ON
SET VERIFY   ON


