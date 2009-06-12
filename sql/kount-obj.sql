--
--
-- kount_obj
--    count schema objects
--
-- Usage:
--     SQL> @kount-obj              -- all objects
--     SQL> @kount-obj scott        -- scott objects
--     SQL> @kount-obj scott pack   -- scott packages
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2009-06
--


SET PAGESIZE 200
SET FEEDBACK OFF
SET VERIFY   OFF

SELECT owner, object_type, count(1) as qtd
  FROM dba_objects
 WHERE owner       LIKE upper('%&&1%')
   AND object_type LIKE upper('%&&2%')
 GROUP BY owner,object_type
 ORDER BY 1,2
/

SET FEEDBACK ON
SET VERIFY   ON


