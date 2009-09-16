column sql_text format a50
set linesize 200
set wrap on

select spid, ses.sid,ses.serial#,ses.server,sql_text
from v$session ses
   , v$process prc
   , v$sql     sql
where ses.username is not null
  and ses.paddr = prc.addr
  and spid = NVL('&1',spid)
  and sql.address    = sql_address
  and sql.hash_value = sql_hash_value
order by spid
/

