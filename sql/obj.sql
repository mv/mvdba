--
--
-- obj.sql
--    user objects
--
-- Usage:
--     SQL> @obj [OWNER]
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2009-08
--


SET PAGESIZE 200
SET FEEDBACK OFF
SET VERIFY   OFF

SELECT owner
     , object_name
     , object_type
     , status
     , last_ddl_time
     , timestamp
     , created
     , subobject_name
  FROM dba_objects
 WHERE 1=1
   AND owner LIKE UPPER('%&&1%')
   AND status = NVL( UPPER('&&2'), status)
 ORDER BY owner
        , object_type
        , object_name
/

SET FEEDBACK ON
SET VERIFY   ON

undef 1
undef 2

