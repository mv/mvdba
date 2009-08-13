--
--
-- grantors-direct.sql
--    app users who gave some DIRECT GRANT because of PL/SQL
--
-- Usage:
--     SQL> @grantors-direct
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2009-08
--


SET PAGESIZE 200
SET LINESIZE 200

COLUMN grantee  FORMAT a30
COLUMN grantor  FORMAT a30

SELECT DISTINCT grantor,grantee
     , DECODE(o.object_type, 'FUNCTION' , o.object_type
                           , 'PROCEDURE', o.object_type
                           , 'PACKAGE'  , o.object_type
                           , NULL
             ) AS "direct!"
     ,'.'
  FROM dba_tab_privs p
     , dba_objects   o
 WHERE grantor NOT IN ('SYS','SYSTEM','XDB')
   AND grantee NOT IN ('DBSMP'
                      ,'EXP_FULL_DATABASE'
                      ,'IMP_FULL_DATABASE'
                      ,'OEM_MONITOR'
                      ,'SELECT_CATALOG_ROLE'
                      )
   AND p.owner NOT LIKE '%SYS%'
   AND p.owner NOT IN ('ORDPLUGINS')
   AND p.grantee = o.owner (+)
 ORDER BY 1,2,3
/


