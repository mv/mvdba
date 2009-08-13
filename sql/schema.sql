--
--
-- schema.sql
--    database schemas
--
-- Usage:
--     SQL> @schema
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2009-08
--


SET PAGESIZE 200

SELECT owner
     , COUNT(object_name) objs
  FROM dba_objects
 WHERE owner NOT IN ('SYS'
                    ,'SYSTEM'
                    ,'PUBLIC'
                    ,'DBSNMP'
                    ,'SYSMAN'
                    ,'OUTLN'
                    ,'ORD'
                    ,'ORDPLUGINS'
                    ,'SI_INFORMTN_SCHEMA'
                    ,'XDB'
                    )
   AND owner NOT LIKE '%SYS'
 GROUP BY owner
 ORDER BY 1
/


