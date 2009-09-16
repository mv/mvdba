/*
  script:   monrbs.sql
  objetivo: lista as operacoes contidas nos segmentos de rollback
  autor:    Josivan
  data:     
*/

select osuser o
      ,username u
      ,segment_name s
      ,sa.sql_text txt
 from  v$session s
      ,v$transaction t
      ,dba_rollback_segs r
      ,v$sqlarea sa
 where s.taddr = t.addr
   and t.xidusn = r.segment_id(+)
   and s.sql_address = sa.address(+)
/
