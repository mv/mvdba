/*
  script:   rbk_ativa.sql
  objetivo: tablespaces que contem segmentos de rollback com transaccoes ativas
  autor:    Josivan
  data:     
*/

  select distinct
         r.tablespace_name
    from dba_rollback_segs r
        ,v$rollname n
        ,v$transaction t
   where r.segment_name = n.name
     and n.usn          = t.xidusn
/

--
-- quantas transacoes ativas estao atribuidas a cada segmento de rollback
--
  select count(*)
        ,r.name
    from v$transaction t
        ,v$rollname r
   where t.xidusn = r.usn
group by r.name
/


--
-- qual o valor OPTIMAL do segmento de rollback
--
select n.name
      ,decode(nvl(s.optsize,0),0,'nao definido') OPTIMAL
  from v$rollname n
      ,v$rollstat s
 where n.usn = s.usn
/
