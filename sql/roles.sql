--
--
-- roles.sql
--    show dictionary
--
-- Usage:
--     SQL> @roles              -- all roles
--     SQL> @roles conn         -- %conn% roles
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2009-06
--


SET PAGESIZE 200
SET FEEDBACK OFF
SET VERIFY   OFF

SELECT *
  FROM dba_roles
 WHERE role LIKE upper('%&&1%')
 ORDER BY 2,1
/

SET FEEDBACK ON
SET VERIFY   ON


