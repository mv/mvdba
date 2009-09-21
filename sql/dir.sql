--
--
-- dir.sql
--    db directories
--
-- Usage:
--     SQL> @dir
--
-- Obs:
--     GRANT CREATE ANY DIRECTORY TO user;
--     GRANT READ,WRITE ON dir_name TO user;
--     CREATE OR REPLACE DIRECTORY data_pump_dir AS  '/u01/exp' ;
--
-- Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
-- 2009-09
--


SET PAGESIZE 200
SET FEEDBACK OFF
SET VERIFY   OFF

COLUMN directory_name   FORMAT A30
COLUMN directory_path   FORMAT A50

SELECT owner
     , directory_name
     , directory_path
  FROM dba_directories
 WHERE 1=1
 ORDER BY 2,1
/

SET FEEDBACK ON
SET VERIFY   ON

undef 1

