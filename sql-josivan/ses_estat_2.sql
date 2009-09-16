/*
  SCRIPT:   SES_ESTAT_2.SQL
  OBJETIVO: ESTATISTICAS POR SESSAO
  AUTOR:    JOSIVAN
  DATA:     2000.02.08   
*/
--
-- coleta de estatisticas por sessao
--
break on sid skip 1
--
  select s.sid
        ,z.osuser    "USUARIO REDE"
        ,z.username  "USUARIO BANCO"
        ,n.name
        ,s.value
    from v$statname n
        ,v$sesstat s
        ,v$session z
   where z.sid       =s.sid
     and n.statistic#=s.statistic#
     and value>0
     and class=64
order by sid,name
/
