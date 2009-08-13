--
--
-- grantees.sql
--    app users who have some GRANT
--
-- Usage:
--     SQL> @grantees
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2009-08
--


SET PAGESIZE 200
SET LINESIZE 200

COLUMN grantee  format a30

SELECT DISTINCT grantee
  FROM dba_tab_privs t
 WHERE grantor NOT IN ('SYS','SYSTEM','XDB')
   AND grantee NOT IN ('DBSMP'
                      ,'EXP_FULL_DATABASE'
                      ,'IMP_FULL_DATABASE'
                      ,'OEM_MONITOR'
                      ,'SELECT_CATALOG_ROLE'
                      )
   AND owner NOT LIKE '%SYS%'
   AND owner NOT IN ('ORDPLUGINS')
 ORDER BY 1
/

SET FEEDBACK ON
SET VERIFY   ON


