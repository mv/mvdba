/*
  script:   ses_kill_2.sql
  objetivo: 
  autor:    Josivan
  data:     
*/

col status format a10
--
set pages 0
--
spool kill.lis 
--
 select sid
       ,serial#
       ,username
       ,status
   from v$session
   where username is not null
     and username not in ('SYSTEM','SYS','DBSNMP','OPS$ORACLE')
order by 3
/
spool off
--
spool kill_session.lis
--
  select 'alter system kill session '||''''||sid||','||serial#||''''||';'
    from v$session
   where username is not null
     and username not in ('SYSTEM','SYS','DBSNMP')
order by username
/
spool off 
--
select 'alter system flush shared_pool;'
  from dual
/

set pages 40
