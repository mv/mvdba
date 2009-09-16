/*
  SCRIPT:   SES_HIT_2.SQL
  OBJETIVO: VERIFICAR O PERCENTUAL DE HITRATIO
  AUTOR:    JOSIVAN
  DATA:     2000.02.08   
*/
  select substr(s.sid,1,3) sid
        ,substr(s.serial#,1,5) ser
        ,substr(osuser,1,8) osuser
        ,spid ospid
        ,substr(status,1,3) stat
        ,substr(command,1,3) com
        ,substr(schemaname,1,10) schema
        ,substr(type,1,3) typ
        ,substr(decode((consistent_gets+block_gets),0,'None',(100*(consistent_gets+block_gets-physical_reads)/(consistent_gets+block_gets))),1,4) "%HIT"
        ,value SqlNet
        ,substr(block_changes,1,5) bchng
        ,substr(consistent_changes,1,5) cchng,s.program
    from v$process p
        ,v$SESSTAT t
        ,v$sess_io i
        ,v$session s
   where i.sid       =s.sid
     and p.addr      =paddr(+)
     and s.sid       =t.sid
     and t.statistic#=135
order by s.logon_time
/
