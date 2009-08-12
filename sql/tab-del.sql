--
--
-- tab.sql
--    delete from user tables
--
-- Usage:
--     SQL> @tab-del
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2009-08
--


SET PAGESIZE 200
SET FEEDBACK OFF
SET VERIFY   OFF

SET HEADING OFF
SET TIMING  OFF

SELECT 'delete from '|| RPAD(table_name, 31, ' ') || ';'
  FROM user_tables
 WHERE 1=1
   AND 1=1
 ORDER BY table_name
/

SET HEADING ON
SET TIMING  ON

SET FEEDBACK ON
SET VERIFY   ON


