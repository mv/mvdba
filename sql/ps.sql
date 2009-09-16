column username format a15
column osuser format a20
column program format a30
set linesize 200
set wrap off

select spid, ses.username, ses.osuser, ses.status, ses.sid,ses.serial#,ses.program,ses.server
from v$session ses
   , v$process prc
where ses.username is not null
  and ses.paddr = prc.addr
  and spid = NVL('&1',spid)
order by spid
/

