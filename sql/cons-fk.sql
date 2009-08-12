--
--
-- cons-fk.sql
--    user constraints - foreign keys
--
-- Usage:
--     SQL> @cons-fk
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2009-08
--


SET PAGESIZE 200
SET FEEDBACK OFF
SET VERIFY   OFF

COLUMN reference_to       FORMAT a40

SELECT cons.table_name
     , cons.constraint_type
     , cons.owner
     , cons.constraint_name
     , cons.status
     , cons.deferrable
     , cons.deferred
     , cons.validated
     , cons.r_owner ||'.'|| ref_to.table_name ||' ('|| LOWER(cons.r_constraint_name) ||') ' ref_to
--   , cons.r_owner
--   , cons.r_constraint_name
  FROM user_constraints   cons
     , all_constraints    ref_to
 WHERE cons.constraint_type = 'R'
   AND cons.r_owner           = ref_to.owner (+)
   AND cons.r_constraint_name = ref_to.constraint_name (+)
 ORDER BY table_name,constraint_name,owner
/

SET FEEDBACK ON
SET VERIFY   ON


