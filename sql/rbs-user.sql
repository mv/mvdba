set linesize 200
set numformat 999g999g999g990

column name format a15
column status format a8
column mega   format 999g990
column xacts  format 999
column waits  format 999
column extents format 9g990

select a.name
     , b.xacts
     , c.sid
     , c.serial#
     , c.username
     , d.sql_text
  from v$rollname a
     , v$rollstat b
     , v$session c
     , v$sqltext d
     , v$transaction e
 where a.usn = b.usn
   and b.usn = e.xidusn
   and c.taddr = e.addr
   and c.sql_address = d.address
   and c.sql_hash_value = d.hash_value
 order by a.name, c.sid, d.piece
/
