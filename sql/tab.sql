--
--
-- tab.sql
--    user tables
--
-- Usage:
--     SQL> @tab [OWNER]
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2009-08
--


SET PAGESIZE 200
SET FEEDBACK OFF
SET VERIFY   OFF

SELECT table_name
     , tablespace_name
     , status
     , logging
     , DECODE(temporary, 'Y', 'TEMPORARY', temporary) as temp
     , partitioned
     , iot_name
     , cluster_name
  FROM dba_tables
 WHERE 1=1
   AND owner LIKE UPPER('%&&1%')
 ORDER BY table_name
/

SET FEEDBACK ON
SET VERIFY   ON

undef 1

