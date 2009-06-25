--
--
-- sess-kill-ospid.sql
--    generate kill -9 por server processes
--
-- Usage:
--     SQL> @sess-kill-ospid           -- all sessions
--     SQL> @sess-kill-ospid active    -- active sessions
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2009-06
--

SET PAGESIZE 100

COLUMN sql      FORMAT A60
COLUMN cmd      FORMAT A20

SELECT s.status
     , s.inst_id
     , s.username
     , 'kill -9 '||p.spid           cmd
     , 'alter system kill session '||chr(39)||s.sid||','||s.serial#||chr(39)||';' sql
  FROM gv$session       s
     , gv$process       p
 WHERE s.paddr   = p.addr(+)
   AND s.audsid <> USERENV('SESSIONID')
   AND status LIKE UPPER('%&&1%')
 ORDER BY s.status
        , s.inst_id
        , s.sid, s.serial#
        ;


