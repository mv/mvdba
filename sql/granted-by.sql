--
--
-- granted-by.sql
--    show grants given by some user
--
-- Usage:
--     SQL> @granted-by         -- all users
--     SQL> @granted-by scott   -- privileges given by SCOTT
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

SELECT 'grant '||privilege                              privilege
     , 'on '||owner||'.'||table_name                    object_name
     , 'to '||grantee                                   grantee
     , decode(grantable,'YES','with grant option','')
     ||'; -- by '||grantor
     ||decode(hierarchy,'YES','hierarchy: yes','')      comments
  FROM dba_tab_privs
 WHERE grantor = UPPER('&&1')
 ORDER BY 2,1,3
/

SET FEEDBACK ON
SET VERIFY   ON


