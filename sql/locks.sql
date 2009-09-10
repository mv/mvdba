--
--
-- locks.sql
--    instance current locks
--
-- Usage:
--     SQL> @locks
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2007-04
--

COLUMN owner            FORMAT A20
COLUMN oracle_username  FORMAT A20
COLUMN locked_mode      FORMAT 999
COLUMN session_id       FORMAT 999

SELECT o.owner
     , o.object_name
     , o.object_type
     , o.status
     , o.last_ddl_time
     , l.session_id
     , l.oracle_username
     , l.locked_mode
  FROM dba_objects o, gv$locked_object l
 WHERE o.object_id = l.object_id
 ORDER BY 1,3,2
     ;

