--
--
-- vw.sql
--    show dictionary
--
-- Usage:
--     SQL> @vw              -- all views
--     SQL> @vw obj          -- %obj% views
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2009-06
--


SET PAGESIZE 200
SET FEEDBACK OFF
SET VERIFY   OFF

SELECT owner
     , view_name
  FROM dba_views
 WHERE view_name   LIKE upper('%&&1%')
 ORDER BY 2,1
/

SET FEEDBACK ON
SET VERIFY   ON


