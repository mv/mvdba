--
--
-- cons-pk.sql
--    user constraints - check constraints
--
-- Usage:
--     SQL> @cons-ck
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2009-08
--


SET PAGESIZE 200
SET FEEDBACK OFF
SET VERIFY   OFF

COLUMN search_condition FORMAT A50

SELECT table_name
     , constraint_type
     , owner
     , constraint_name
     , status
     , deferrable
     , deferred
     , validated
     , search_condition
  FROM user_constraints
 WHERE constraint_type = 'C'
   AND 1=1
 ORDER BY table_name,constraint_name,owner
/

SET FEEDBACK ON
SET VERIFY   ON


