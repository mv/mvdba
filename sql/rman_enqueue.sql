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

COLUMN sid                  FORMAT 999999
COLUMN serial#              FORMAT 999999
COLUMN username             FORMAT A20
COLUMN program              FORMAT A30
COLUMN module               FORMAT A20
COLUMN action               FORMAT A20

SELECT s.sid
     , serial#
     , logon_time "logon"
     , status
     , username
     , program
     , module
     , action
--   , l.*
  FROM gv$session s
     , gv$enqueue_lock l
 WHERE l.sid = s.sid
   AND l.TYPE = 'CF'
   AND l.ID1 = 0
   AND l.ID2 = 2
 ORDER BY 3,1,2
/

