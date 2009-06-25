--
--
-- grants.sql
--    show dictionary
--
-- Usage:
--     SQL> @grants              -- all objects
--     SQL> @grants scott        -- scott objects
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2009-06
--


SET PAGESIZE 200
SET FEEDBACK OFF
SET VERIFY   OFF

column object_name  format a40
column comments     format a40
column privilege    format a15

SELECT 'grant '||privilege                              privilege
     , 'on '||owner||'.'||table_name                    object_name
     , 'to '||grantee                                   grantee
     , decode(grantable,'YES','with grant option','')
     ||'; -- by '||grantor
     ||decode(hierarchy,'YES','hierarchy: yes','')      comments
  FROM dba_tab_privs
 WHERE table_name LIKE upper('%&&1%')
 ORDER BY 2,1,3
/

SET FEEDBACK ON
SET VERIFY   ON


