--
--
-- cons-pk.sql
--    user constraints - primary keys
--
-- Usage:
--     SQL> @cons-pk
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2009-08
--


SET PAGESIZE 200
SET FEEDBACK OFF
SET VERIFY   OFF

SELECT table_name
     , constraint_type
     , owner
     , constraint_name
     , status
     , deferrable
     , deferred
     , validated
     , index_owner
     , index_name
  FROM user_constraints
 WHERE constraint_type = 'P'
   AND 1=1
 ORDER BY table_name,constraint_name,owner
/

SET FEEDBACK ON
SET VERIFY   ON


