--
--
-- sess.sql
--    current sessions
--
-- Usage:
--     SQL> @sess           -- all sessions
--     SQL> @sess active    -- active sessions
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2009-06
--

SET PAGESIZE 100

SELECT s.status
     , s.sid
     , s.serial#
     , s.inst_id
     , s.username
     , s.logon_time
     , p.pid                           -- oracle internal pid (v$process)
     , p.spid                          -- server os pid
     , s.process                "CPID" -- client os pid
     , substr(p.program,1,30)   program
     , substr(s.module,1,20)    module
     , substr(s.action,1,20)    action
     , substr(w.event,1,20)     event
--   , s.osuser                 "Client User"
--   , s.program                "Client Program"
--   , s.machine                "Machine"
     , lockwait                 "Lock Wait"
  FROM gv$session       s
     , gv$process       p
     , gv$session_wait  w
 WHERE s.paddr   = p.addr(+)
   AND w.sid(+)  = s.sid
   AND s.audsid <> USERENV('SESSIONID')
   AND status LIKE UPPER('%&&1%')
 ORDER BY s.status
        , s.inst_id
        , s.sid, s.serial#
        ;

