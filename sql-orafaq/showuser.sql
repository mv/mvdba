rem This is the showuser.sql query. It does a display of oracle processes

spool showuser.out

column serial# format 999999

select substr(a.username,1,10) USERNAME
     , substr(a.osuser,1,8) OSUSER
     , substr(b.spid,1,6) SRVPID
     , substr(to_char(a.sid),1,3) ID
     , a.serial#
     , substr(a.machine,1,8) HOST
     , substr(a.program,1,25) PROGRAM
  from v$process b, v$session a
 where a.paddr = b.addr
 order by a.username
/

spool off

