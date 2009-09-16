#showsql

set linesize 300
set numformat 9g999g990
column event    format a30
column username format a20

----- temp
select * from v$waitstat;

column p1text format a15
column p2text format a15
column p3text format a15
select * from v$session_wait;
----- temp end

select *
  from v$system_event
 order by 2
/
