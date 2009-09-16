set linesize 200
set numformat 999g999g999g990

column name    format a15
column status  format a8
column mega    format 999g990
column xacts   format 999
column waits   format 999
column extents format 9g990

break on 1
compute sum of "rssize mega" on 1
compute sum of rssize        on 1
select a.name
     , b.extents
     , b.rssize
     , b.rssize/1024/1024 "rssize mega"
     , b.gets
     , b.optsize/1024/1024 "optsize mega"
     , status
     , b.xacts
     , b.waits
     , 1
  from v$rollname a
     , v$rollstat b
where a.usn = b.usn
order by 1
/

