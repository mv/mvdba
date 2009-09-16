/*
  SCRIPT:   SES_ESTAT_1.SQL
  OBJETIVO: ACTUALIZAR AS ESTATISTICAS DA TABELA
  AUTOR:    JOSIVAN
  DATA:     2000.02.08   
*/
select vss.sid
      ,vs.name
      ,vss.value
      ,vse.osuser
  from v$sesstat vss
      ,v$statname vs
      ,v$session vse
 where vss.STATISTIC# = vs.STATISTIC#
   and vse.sid        = vss.sid
   and vse.osuser     = '&nome'
/

