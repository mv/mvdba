/*
  script:   rbk_transacao.sql
  objetivo: 
  autor:    Josivan
  data:     
*/

select osuser       o
      ,username     u
      ,segment_name s
      ,sa.sql_text  txt
  from v$session s
      ,v$transaction t
      ,dba_rollback_segs r
      ,v$sqlarea sa
 where t.xidusn      = r.segment_id(+)
   and s.taddr       = t.addr
   and s.sql_address = sa.address(+)
/
