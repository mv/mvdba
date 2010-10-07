--
--
-- fra.sql
--    Flash Recoverable Area
--
-- Usage:
--     SQL> @fra
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2010-10
--


SET PAGESIZE 200
SET FEEDBACK OFF
SET VERIFY   OFF

COLUMN name format a15

SELECT name
     , number_of_files
     , space_limit/1024/1024/1024               space_limit_g
     , space_used/1024/1024/1024                space_used_g
     , space_reclaimable/1024/1024/1024         reclaimable_g
     , ROUND(space_used/space_limit*100, 2)     perc_used
  FROM v$recovery_file_dest
     ;


