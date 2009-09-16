
set linesize 200
column sql_text format a50

Prompt "Locked"
select b.username
     , b.serial#
     , d.id1
     , a.sql_text
  from v$session b, v$lock d, v$sqltext a
 where b.lockwait = d.kaddr
   and a.address = b.sql_address
   and a.hash_value = b.sql_hash_value
/

Prompt "Locking"
select a.serial#
     , a.sid
     , a.username
     , b.id1
     , c.sql_text
  from v$session a, v$lock b, v$sqltext c
 where b.id1 in (select distinct e.id1
                   from v$session d, v$lock e
                  where d.lockwait = e.kaddr)
   and a.sid = b.sid
   and c.hash_value = a.sql_hash_value
   and b.request = 0
/
