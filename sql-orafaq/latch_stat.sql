/* 
** Display latch statistics by latch name. 
*/ 

set pagesize 200
set numformat 999g999g990
set trimspool on

column name format a40  heading 'LATCH NAME' 
column pid              heading 'HOLDER PID' 
column no_wait_ratio        heading "no wait | ratio%"            format 999d00
column will_towait_ratio    heading "willing | to wait | ratio %" format 999d00


select c.name
  -- , a.addr
     , a.gets
     , a.misses
     , a.sleeps
     , (a.gets - a.misses)/ decode(a.gets,0,1,a.gets)*100 will_towait_ratio    
     , a.immediate_gets
     , a.immediate_misses
     , (a.immediate_gets - a.immediate_misses) / decode(a.immediate_gets,0,1,a.immediate_gets)*100 no_wait_ratio
  -- , b.pid 
  from v$latch a
     , v$latchholder b
     , v$latchname c 
 where a.addr = b.laddr(+) 
   and a.latch# = c.latch# 
   and c.name like '&&latch_name%' 
 order by 1 --a.latch#
/
 