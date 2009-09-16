/*
  script:   rbk_contencao.sql
  objetivo: segmentos de rollback, percentual de contencao
  autor:    Josivan
  data:     
*/

--
set linesize 120
--

  select n.name
        ,round(100*s.waits/s.gets) "%Cont"
    from v$rollname n
        ,v$rollstat s
   where n.usn = s.usn
order by n.name
/


  select substr(n.name,1,6)           rol
        ,round(s.extents/1024/1024)   ext
        ,round(s.writes/1024/1024)    wri
        ,s.waits   
        ,round(s.gets/1024/1024)      get
        ,s.optsize
        ,round(s.hwmsize/1024/1024)   hwm
        ,s.shrinks
        ,round(100*s.waits/s.gets) "%Cont"
        ,s.extends
    from v$rollname n
        ,v$rollstat s
   where n.usn = s.usn
order by n.name
/
