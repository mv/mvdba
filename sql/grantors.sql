--
--
-- grantors.sql
--    app users who gave some GRANT
--
-- Usage:
--     SQL> @grantors
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2009-08
--


SET PAGESIZE 200
SET LINESIZE 200

COLUMN grantee  FORMAT a30
COLUMN grantor  FORMAT a30

SELECT DISTINCT grantor,grantee
     ,'.'
  FROM dba_tab_privs p
 WHERE grantor NOT IN ('SYS','SYSTEM','XDB')
   AND grantee NOT IN ('DBSMP'
                      ,'EXP_FULL_DATABASE'
                      ,'IMP_FULL_DATABASE'
                      ,'OEM_MONITOR'
                      ,'SELECT_CATALOG_ROLE'
                      )
   AND p.owner NOT LIKE '%SYS%'
   AND p.owner NOT IN ('ORDPLUGINS')
 ORDER BY 1,2,3
/


